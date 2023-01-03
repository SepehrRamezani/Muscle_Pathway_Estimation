function WrapObject_Calculator(filedata)
Basepath=filedata.Basepath;
counter=0;
Ankle=filedata.Ankle;
Knee=filedata.Knee;
Trial=filedata.Trial;
Subject=filedata.Subject;
for S=1:length(Subject)
    for K=1:length(Knee)
        for Ank=1:length(Ankle)
            counter=counter+1;
            combo_lable=[];
            MCP_XYZ_Data_Combined=[];
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(Ank),"_L_",Trial(T));
                datadir=append(Basepath,"\Mucle_Center\",Subject(S),"\",Subject(S),"_",fname,"_MuscleCenter\",fname,"_PointKinematics_MUCE_pos.sto");
                if isfile(datadir)
                    MCP_Data=importdata(datadir);
                    MCP_XYZ_Data_Combined=[MCP_XYZ_Data_Combined;MCP_Data.data(:,[2:4])];
                    MCPData.Subject(S).(fname).data = MCP_Data.data(:,[2:4]);
                else
                    fprintf('Warning Data of %s_%s was not found \n',Subject(S),fname);
                end
            end
            fcoboname=append(Knee(K),"_",Ankle(Ank));
            MCPData.Subject(S).(fcoboname).data = MCP_XYZ_Data_Combined;
            % For visualizing purpose the x data is flipped
            Flipped_MCP_XYZ_Data_Combined=-1*MCP_XYZ_Data_Combined;
            [MCP_XYZ_Sorted, o] = sortrows(Flipped_MCP_XYZ_Data_Combined,2);
            [coef,Si] = polyfit(MCP_XYZ_Sorted(:,2),MCP_XYZ_Sorted(:,1), 3);
            curve_x=MCP_XYZ_Sorted(1,2):(MCP_XYZ_Sorted(end,2)-MCP_XYZ_Sorted(1,2))/50:MCP_XYZ_Sorted(end,2);
            cruve_y=polyval(coef,curve_x,Si);
            %y' = 3ax^2 + 2bx + c
            %y'' = 6ax+ 2b
            %x = (-2b)/(6a)
            ubx = (-1*coef(2))/(3*coef(1));
            lbx = 0.03; 
            MCP_XYZ_trimed=MCP_XYZ_Sorted(MCP_XYZ_Sorted(:,2)>=lbx,:);
%             MCP_XYZ_trimed=MCP_XYZ_Sorted(MCP_XYZ_Sorted(:,2)<=ubx & MCP_XYZ_Sorted(:,2)>=lbx,:);
            %         polyval(coef,x,S);
            fun = @(w)sseval(w,MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1));
            x0 = [0.1;0.1;-0.05];
            options = optimset('MaxFunEvals',100000,'MaxIter',100000,'TolFun',1e-10);
            [Wrapping_param(counter,:),fval,exitflag] = fminsearch(fun,x0,options);
            r=Wrapping_param(counter,1);
            y=Wrapping_param(counter,2);
            x=Wrapping_param(counter,3);
            if exitflag
                fprintf('Wrap Object parameters of %s is r=%3.4f y=%3.4f x=%3.4f \n',fname,r,y,x);
            else
                fprintf('Warning: Wrap Object of %s has not found best answer is r=%3.4f y=%3.4f x=%3.4f \n',fname,r,y,x);
            end
            fig=figure;
            fig.Position(1)=-1800;
            fig.Position(3:4)=[1600,400];
            MCPData.(Subject(S)).(fcoboname).WrappingPar = Wrapping_param(counter,:);
            Wrapping_ydata=CurveFun(Wrapping_param(counter,:),MCP_XYZ_trimed(:,2));
            plot(MCP_XYZ_Sorted(:,2),MCP_XYZ_Sorted(:,1),curve_x,cruve_y);
            hold on
            plot(MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1));
            plot(MCP_XYZ_trimed(:,2),Wrapping_ydata,'LineWidth',1.5);
            legend("Rawdata","PolyLine","TrimedData","WrapObj")
            title(fname)
            hold off
             
        end
    end
end
save([Basepath '\MCP_data.mat'],'MCPData');

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
