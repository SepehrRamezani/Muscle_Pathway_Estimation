function WrapObject_Calculator(filedata)
import org.opensim.modeling.*;
Basepath=filedata.Basepath;
counter=0;
Ankle=filedata.Ankle;
Knee=filedata.Knee;
Trial=filedata.Trial;
Subject=filedata.Subject;
for S=1:length(Subject)
    %% findind muscle insertion
    Trc_path=append(filedata.Basepath,'\Moca\',Subject(S),'\');
    model=Model(append(Trc_path,Subject(S),"_raj_modified.osim"));
   

    for K=1:length(Knee)
        %% getting muscle insertion
        kneeangle=double(erase(Knee(K),"K"))/180*pi();
        state = model.initSystem();
        kneecoord=model.updCoordinateSet().get('knee_angle_l');
        kneecoord.setValue(state, kneeangle);
        model.realizePosition(state);
        kneecoord.getValue(state);
%         state = model.initSystem();
        force = model.getForceSet().get('gaslat_l');
        muscle = Millard2012EquilibriumMuscle.safeDownCast(force);
        MuscinsertionPoint=muscle.get_GeometryPath().getPathPointSet.get(0);
        Inslocaion=MuscinsertionPoint.getLocation(state);
        Parntframe=MuscinsertionPoint.getParentFrame();
        tibibody=model.getBodySet.get('tibia_l');
        MuMareker=Marker('MU-insertion',Parntframe,Inslocaion);
        MuMareker.changeFramePreserveLocation(state,tibibody);
        MuscinsertionNew=MuMareker.get_location();
        Mucinsertion=[MuscinsertionNew.get(0),MuscinsertionNew.get(1)];
        %% Optimazation
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
            
%             Opensim y -> code -x
%             Opensim x -> code -y

            insertionpoint=-1*[Mucinsertion(2),Mucinsertion(1)];
%             insertionpoint=-1*[-0.04,-0.03];

            fun = @(w)sseval(w,MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1),insertionpoint);
            x0 = [0.1;0.1;-0.05];
            options = optimoptions('fmincon','ConstraintTolerance',1e-9,'MaxIterations',1e8);
%             options = optimoptions();
            Aa = [];
            Bb = [];
            Aeq = [];
            beq = [];
            lb=[0,-5,-5];
            ub=[5,5,0.1];
            nonlcon=[];
            [Wrapping_param(counter,:),fval,exitflag] = fmincon(fun,x0,Aa,Bb,Aeq,beq,lb,ub,nonlcon,options);
            fval
            r=Wrapping_param(counter,1);
%           Base of opensim axis
            xc=Wrapping_param(counter,2);
            yc=Wrapping_param(counter,3);
            if exitflag
                fprintf('Wrap Object parameters of %s is r=%3.4f y=%3.4f x=%3.4f \n',fname,r,yc,xc);
            else
                fprintf('Warning: Wrap Object of %s has not found best answer is r=%3.4f y=%3.4f x=%3.4f \n',fname,r,yc,xc);
            end
            fig=figure;
            fig.Position(1)=-1800;
            fig.Position(3:4)=[1600,400];
            MCPData.(Subject(S)).(fcoboname).WrappingPar = Wrapping_param(counter,:);
            fulltestdata=linspace(xc-r,xc+r,120);
            Wrapping_ydata=CurveFun(Wrapping_param(counter,:),fulltestdata);
            Wrapping_ydata_trim=CurveFun(Wrapping_param(counter,:),MCP_XYZ_trimed(:,2));
            plot(MCP_XYZ_Sorted(:,2),MCP_XYZ_Sorted(:,1),curve_x,cruve_y);
            hold on
            plot(MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1));
            plot(MCP_XYZ_trimed(:,2),Wrapping_ydata_trim(1,:),'LineWidth',1.5);
            plot(fulltestdata,Wrapping_ydata(1,:),'LineWidth',1.5);
            plot(insertionpoint(1),insertionpoint(2),'b*')
            legend("Rawdata","PolyLine","TrimedData","WrapObj")
            title(fname)
            hold off
             
        end
    end
end
save([Basepath '\MCP_data.mat'],'MCPData');

    function sse = sseval(parm,xdata,ydata,inspt)
        A = parm(1);
        B = parm(2);
        C = parm(3);
        n = length(xdata);
        wc=0.0001;
        d=norm([B,C]-inspt)-A;
        %d= sqrt((B-inspt(1)).^2 +(C-inspt(2)).^2)-A ;
        %Obj1=1/n*(sum(abs(ydata - sqrt(A.^2 - (xdata-B).^2) - C)))
        Obj1=1/n*(sum(abs((ydata -C).^2+(xdata-B).^2-A^2)));
        Obj2=wc*10.^((-1000).*d);
        sse =Obj1+Obj2;
    end
    function ydata = CurveFun(parm,xdata)
        A = parm(1);
        B = parm(2);
        C = parm(3);
        ydata(1,:) = sqrt(A.^2-(xdata-B).^2)+C;
        ydata(2,:)= -sqrt(A.^2-(xdata-B).^2)+C;
    end
end
