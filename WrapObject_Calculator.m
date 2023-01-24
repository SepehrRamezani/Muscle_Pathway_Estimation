function WrapObject_Calculator(filedata)
import org.opensim.modeling.*;
Basepath=filedata.Basepath;
counter=0;
plotflage=0;
Subject=[];
fcoboname=filedata.fcoboname;
load([Basepath '\MCP_data.mat'])
for S=1:length(fcoboname) 
    trial_name=char(fcoboname(S));
    indxuderline=strfind(trial_name,'_');
    Subject=trial_name(1:indxuderline(1)-1);
    Knee=string(trial_name(indxuderline(1)+1:indxuderline(2)-1));
    Ankle=string(trial_name(indxuderline(2)+1:end));
    %% findind muscle insertion
    Trc_path=append(filedata.Basepath,'\Moca\',Subject,'\');
    model=Model(append(Trc_path,Subject,"_raj_modified.osim"));
    %% getting muscle insertions
    kneeangle=deg2rad(double(erase(Knee,"K")));
    if contains(Ankle,"P")
        ankleangle=-1*deg2rad(double(erase(Ankle,"P")));
    else
        ankleangle=1*deg2rad(double(erase(Ankle,"D")));
    end
        state = model.initSystem();
        tibibody=model.getBodySet.get('tibia_l');
        Kneecoord=model.updCoordinateSet().get('knee_angle_l');
        Anklecoord=model.updCoordinateSet().get('ankle_angle_l');
        Kneecoord.setValue(state, kneeangle);
        Anklecoord.setValue(state, ankleangle);
        model.realizePosition(state);
        Kneecoord.getValue(state);
%         state = model.initSystem();
        force = model.getForceSet().get('gaslat_l');
        muscle = Millard2012EquilibriumMuscle.safeDownCast(force);
%         start point
        MuscinsertionPoint=muscle.get_GeometryPath().getPathPointSet.get(0);
        SInslocaion=MuscinsertionPoint.getLocation(state);
        SParntframe=MuscinsertionPoint.getParentFrame();
        SMuMareker=Marker('MU-insertion',SParntframe,SInslocaion);
        SMuMareker.changeFramePreserveLocation(state,tibibody);
        SMuscinsertionNew=SMuMareker.get_location();
        SMucinsertion=[SMuscinsertionNew.get(0),SMuscinsertionNew.get(1)];
%         end point
        MuscinsertionPoint=muscle.get_GeometryPath().getPathPointSet.get(1);
        EInslocaion=MuscinsertionPoint.getLocation(state);
        EParntframe=MuscinsertionPoint.getParentFrame();
        EMuMareker=Marker('MU-insertion',EParntframe,EInslocaion);
        EMuMareker.changeFramePreserveLocation(state,tibibody);
        EMuscinsertionNew=EMuMareker.get_location();
        EMucinsertion=[EMuscinsertionNew.get(0),EMuscinsertionNew.get(1)];
        
        %% Optimazation
        counter=counter+1;
        combo_lable=[];
        MCP_XYZ_Data_Combined=[];
        for T=1:3
            fname=append(erase(trial_name,append(Subject,"_")),"_L_",string(T));
            datadir=append(Basepath,"\Mucle_Center\",Subject,"\",fcoboname(S),"_L_",string(T),"_MuscleCenter\",fname,"_PointKinematics_MUCE_pos.sto");
            if isfile(datadir)
                MCP_Data=importdata(datadir);
                MCP_XYZ_Data_Combined=[MCP_XYZ_Data_Combined;MCP_Data.data(:,[2:4])];
%                 MCPData.(fcoboname(S)).data = MCP_Data.data(:,[2:4]);
            else
                fprintf('Warning: MCP of %s was not found \n',fname);
            end
        end
%             fcoboname=append(Knee(K),"_",Ankle(Ank));
            MCPData.(fcoboname(S)).data = MCP_XYZ_Data_Combined;
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
            lbx = 0.0; 
            MCP_XYZ_trimed=MCP_XYZ_Sorted(MCP_XYZ_Sorted(:,2)>=lbx,:);
%             MCP_XYZ_trimed=MCP_XYZ_Sorted(MCP_XYZ_Sorted(:,2)<=ubx & MCP_XYZ_Sorted(:,2)>=lbx,:);
            
%             Opensim y -> code -x
%             Opensim x -> code -y

            insertionpoints=-1*[SMucinsertion(2),SMucinsertion(1);EMucinsertion(2),EMucinsertion(1)];
%             insertionpoint=-1*[-0.04,-0.03];

            fun = @(w)sseval(w,MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1),insertionpoints);
            x0 = [0.1;0.1;-0.05];
            options = optimoptions('fmincon','ConstraintTolerance',1e-9,'MaxIterations',1e8);
%             options = optimoptions();
            Aa = [];
            Bb = [];
            Aeq = [];
            beq = [];
            lb=[0,-1,-1];
            ub=[1,1,0.1];
            nonlcon=[];
            [Wrapping_param,fval,exitflag] = fmincon(fun,x0,Aa,Bb,Aeq,beq,lb,ub,nonlcon,options);
            r=Wrapping_param(1);
%           Base of plot axis
            xc=Wrapping_param(2);
            yc=Wrapping_param(3);
            if exitflag
                fprintf('Wrap Object parameters of %s is r=%3.4f y=%3.4f x=%3.4f \n',fcoboname(S),r,yc,xc);
            else
                fprintf('Warning: Wrap Object of %s has not found best answer is r=%3.4f y=%3.4f x=%3.4f \n',fcoboname(S),r,yc,xc);
            end
            
            MCPData.(fcoboname(S)).WrappingPar = Wrapping_param;
            fulltestdata=linspace(xc-r,xc+r,120);
            Wrapping_ydata=CurveFun(Wrapping_param,fulltestdata);
            Wrapping_ydata_trim=CurveFun(Wrapping_param,MCP_XYZ_trimed(:,2));
            if plotflage
            fig=figure;
            fig.Position(1)=-1800;
            fig.Position(3:4)=[1600,400];
            plot(MCP_XYZ_Sorted(:,2),MCP_XYZ_Sorted(:,1),curve_x,cruve_y);
            hold on
            plot(MCP_XYZ_trimed(:,2),MCP_XYZ_trimed(:,1));
            plot(MCP_XYZ_trimed(:,2),Wrapping_ydata_trim(1,:),'LineWidth',1.5);
            plot(fulltestdata,Wrapping_ydata(1,:),'LineWidth',1.5);
            plot(insertionpoints(:,1),insertionpoints(:,2),'b*')
            legend("Rawdata","PolyLine","TrimedData","WrapObj")
            title(fcoboname(S))
            hold off
            end
             
%         end
    
end
save([Basepath '\MCP_data.mat'],'MCPData');

    function sse = sseval(parm,xdata,ydata,inspts)
        A = parm(1);
        B = parm(2);
        C = parm(3);
        n = length(xdata);
        wc1=0.0001;
        wc2=0.0001;
        d1=norm([B,C]-inspts(1,:))-A;
        d2=norm([B,C]-inspts(2,:))-A;
        %d= sqrt((B-inspt(1)).^2 +(C-inspt(2)).^2)-A ;
        %Obj1=1/n*(sum(abs(ydata - sqrt(A.^2 - (xdata-B).^2) - C)))
        Obj1=1/n*(sum(abs((ydata -C).^2+(xdata-B).^2-A^2)));
        Obj2=wc1*10.^((-1000).*d1);
        Obj3=wc2*10.^((-1000).*d2);
        sse =Obj1+Obj2+Obj3;
    end
    function ydata = CurveFun(parm,xdata)
        A = parm(1);
        B = parm(2);
        C = parm(3);
        ydata(1,:) = sqrt(A.^2-(xdata-B).^2)+C;
        ydata(2,:)= -sqrt(A.^2-(xdata-B).^2)+C;
    end
    
end
