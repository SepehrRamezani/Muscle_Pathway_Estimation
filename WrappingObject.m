clear all
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};

Trc_path=append(Basepath);

% wrapping object optimization
% put in opensim get moment arm 
subject=["p7"];
Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
Data.trial=[];
MCP_XYZ_Data_Combined=[];
counter=0;
for K=1:length(Knee)
    for A=1:length(Ankle)
        counter=counter+1;
        combo_lable=[];
        for T=1:length(Trial)
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            datadir=append(Trc_path,"\Mucle_Center\",fname,"_MuscleCenter\",fname,"_PointKinematics_MUCE_pos.sto");
            MCP_Data=importdata(datadir);
            MCP_XYZ_Data_Combined=[MCP_XYZ_Data_Combined;MCP_Data.data(:,[2:4])];
            Data.(fname).data = MCP_Data.data(:,[2:4]);
        end
        fcoboname=append(Knee(K),"_",Ankle(A));
        Data.(fcoboname).data = MCP_XYZ_Data_Combined;
        % For visualizing purpose the x data is flipped 
        MCP_XYZ_Data_Combined=-1*MCP_XYZ_Data_Combined;
        [MCP_XYZ_Sorted, o] = sortrows(MCP_XYZ_Data_Combined,2);
%         MCP_XYZ_Sorted(:,1)=-1*MCP_XYZ_Sorted(:,1);
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
save([Basepath '\MCP_data.mat'],'Data');
count = 1;
colors = distinguishable_colors(15);
Knee = {'K000','K030','K060','K090','K110'};
Ankle = {'000','D10','P30'};
Trial = {'1','2','3'};
% figure
% hold on
% plot(Data.Laterals0(:,2),ye, 'Linewidth',2, 'DisplayName','Combined')
for K=1:length(Knee)
    for A=1:length(Ankle)
        figure
        hold on
        for T=1:length(Trial)
            x = Data.(strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}))(:,2);
            y = Data.(strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}))(:,1);
            plot(-1*x{:,1}, -1*y{:,1}, 'DisplayName',strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}), 'color', colors(count,:))
%             plot(x{:,1}, y{:,1}, 'DisplayName',strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}), 'color', colors(count,:))
        end
        ye = CurveFun(Wrapping_param(count,:), Data.(strcat("Laterals",trial{count}))(:,2));
        plot(Data.(strcat("Laterals",trial{count}))(:,2), ye)
        xlim([0 0.35])
        ylim([0 0.16])
        hold off
        count = count + 1;
    end
end
count = 1;
figure
hold on
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            x = Data.(strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}))(:,2);
            y = Data.(strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}))(:,1);
            plot(-1*x{:,1}, -1*y{:,1}, 'DisplayName',strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}), 'color', colors(count,:))
%           plot(x{:,1}, y{:,1}, 'DisplayName',strcat(Knee{K},"_",Ankle{A},"_L_",Trial{T}), 'color', colors(count,:))
        end      
        count = count + 1;
    end
end
xlim([0 0.35])
ylim([0 0.16])
hold off
% plot(Data.Laterals0(:,2), poly,'Linewidth',2,'DisplayName','Polynomial Fit to Data')
% legend
% hold off


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

