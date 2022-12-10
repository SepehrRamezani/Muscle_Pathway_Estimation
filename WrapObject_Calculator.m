function WrapObject_Calculator(Data)
Basepath=Data.Basepath;
Data.trial=[];
MCP_XYZ_Data_Combined=[];
counter=0;
Ankle=Data.Ankle;
Knee=Data.Knee;
Trial=Data.Trial;
Subject=Data.Subject;
for S=1:length(Subject)
    for K=1:length(Knee)
        for Ank=1:length(Ankle)
            counter=counter+1;
            combo_lable=[];
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(Ank),"_L_",Trial(T));
                datadir=append(Basepath,"\Mucle_Center\",Subject,"\",Subject,"_",fname,"_MuscleCenter\",fname,"_PointKinematics_MUCE_pos.sto");
                MCP_Data=importdata(datadir);
                MCP_XYZ_Data_Combined=[MCP_XYZ_Data_Combined;MCP_Data.data(:,[2:4])];
                Data.(fname).data = MCP_Data.data(:,[2:4]);
            end
            fcoboname=append(Knee(K),"_",Ankle(Ank));
            Data.(fcoboname).data = MCP_XYZ_Data_Combined;
            % For visualizing purpose the x data is flipped
            MCP_XYZ_Data_Combined=-1*MCP_XYZ_Data_Combined;
            [MCP_XYZ_Sorted, o] = sortrows(MCP_XYZ_Data_Combined,2);
            [coef,S] = polyfit(MCP_XYZ_Sorted(:,2),MCP_XYZ_Sorted(:,1), 3);
            curve_x=MCP_XYZ_Sorted(1,2):(MCP_XYZ_Sorted(end,2)-MCP_XYZ_Sorted(1,2))/50:MCP_XYZ_Sorted(end,2);
            cruve_y=polyval(coef,curve_x,S);
            %y' = 3ax^2 + 2bx + c
            %y'' = 6ax+ 2b
            %x = (-2b)/(6a)
            ubx = (-1*coef(2))/(3*coef(1));
            lbx = 0.03;
            MCP_XYZ_trimed=MCP_XYZ_Sorted(MCP_XYZ_Sorted(:,2)<=ubx & MCP_XYZ_Sorted(:,2)>=lbx,:);
            %         polyval(coef,x,S);
            fun = @(w)sseval(w,MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1));
            x0 = [0.1;0.1;-0.05];
            options = optimset('MaxFunEvals',100000,'MaxIter',100000,'TolFun',1e-10);
            Wrapping_param(counter,:) = fminsearch(fun,x0,options);
            Data.(fcoboname).WrappingPar = Wrapping_param(counter,:);
            Wrapping_ydata=CurveFun(Wrapping_param(counter,:),MCP_XYZ_trimed(:,2));
        end
    end
end
save([Basepath '\MCP_data.mat'],'Data');
    function sse = sseval(parm,xdata,ydata)
        A = parm(1);
        B = parm(2);
        C = parm(3);
        n = length(xdata);
        sse = 1/n*sum(abs(ydata - sqrt(A.^2 - (xdata-B).^2) - C));
    end
    function ydata = CurveFun(parm,xdata)
        A = parm(1);
        B = parm(2);
        C = parm(3);
        ydata = sqrt(A.^2-(xdata-B).^2)+C;
    end
end
