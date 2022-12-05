% US_Data_prepration.m US-> mat postion relative centerline from Us image
% Motion_Capture_Data_prepration.m   trc-> IK : position of prob()
% combine US and IK and run Analysis   final postion of centerline relative
% to shank oring ()
% wrapping object optimization
% put in opensim get moment arm 

for y = 1:15

[s, o] = sortrows(Data.(trial(y)),Data.(trial(y))(:,1));
% Following two lines commented because they chnage the quadrant that the
% data is in
s = -1 * s.Var2;
Data.(trial(y)){:,1} = -1 * Data.(trial(y)){:,1};
Data.(trial(y)) = [Data.(trial(y)){o,1}, s.Var2, Data.(trial(y)){o,3}];
L = length(Data.(trial(y)));

latfit = polyfit(Data.(trial(y))(:,2),Data.(trial(y))(:,1), 3);

poly = latfit(1)*Data.(trial(y))(:,2).^3 + latfit(2)*Data.(trial(y))(:,2).^2 + latfit(3)*Data.(trial(y))(:,2).^1 + latfit(4);
%y' = 3ax^2 + 2bx + c
%y'' = 6ax+ 2b
%x = (-2b)/(6a)
%val = polyval(poly,x)
% lbx = Laterals0(1,2); changed so tht the lower bound is what the upper
% bound would normally be so that the wraping object better fits distal data points
ubx = (-2*latfit(2))/(6*latfit(1));
% lbx = (-2*latfit(2))/(6*latfit(1));
% lbx = (((-2*latfit(2)) + sqrt(((2*latfit(2)).^2) - (12 * latfit(1) * latfit(3)))) / (2*latfit(1)));
lbx = -0.03;
% ubx = Laterals0(end,2);
redlat = zeros(L,3);
k = 0;
for i = 1:L
    %data<lbx is original before I change the data to all be positive 
    if Data.(strcat("Laterals",trial{y}))(i,2) > lbx
        redlat(i,:) = Data.(strcat("Laterals",trial{y}))(i,:);
        if k == 0
            p = i;
        end
        k = k+1;
    end
end
redlat = redlat(p:k+p-1,:);


fun = @(w)sseval(w,redlat(:,2),redlat(:,1));
x0 = [0.1;0.1;-0.05];
options = optimset('MaxFunEvals',100000,'MaxIter',100000,'TolFun',1e-10);
bestx(y,:) = fminsearch(fun,x0,options);


ye=CurveFun(bestx(y,:),Data.(strcat("Laterals",trial{y}))(:,2));

end

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
        ye = CurveFun(bestx(count,:), Data.(strcat("Laterals",trial{count}))(:,2));
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

