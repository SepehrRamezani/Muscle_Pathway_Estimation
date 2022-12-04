clc, clearvars, clear 
close all
%composite file with pathway coordinates
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
basepath=Pardata{1};
b=append(basepath,'\Experiment19(P7).xlsx');
x = -1.5:0.01:3.5;
y = sqrt(6-(x-1).^2)-2;
yr = y+rand(1,length(y));
xr = x+rand(1,length(x));

Data.K000_000_L_1 = zeros(3,3);
Data.K000_000_L_1 = readtable(b,'Sheet','Sheet1','Range','A2:C4');
Data.K000_000_L_2 = zeros(23,3);
Data.K000_000_L_2 = readtable(b,'Sheet','Sheet1','Range','D2:F24');
Data.K000_000_L_3 = zeros(20,3);
Data.K000_000_L_3 = readtable(b,'Sheet','Sheet1','Range','G2:I21');

Data.K000_D10_L_1 = zeros(15,3);
Data.K000_D10_L_1 = readtable(b,'Sheet','Sheet1','Range','J2:L16');
Data.K000_D10_L_2 = zeros(22,3);
Data.K000_D10_L_2 = readtable(b,'Sheet','Sheet1','Range','M2:O23');
Data.K000_D10_L_3 = zeros(15,3);
Data.K000_D10_L_3 = readtable(b,'Sheet','Sheet1','Range','P2:R16');

Data.K000_P30_L_1 = zeros(15,3);
Data.K000_P30_L_1 = readtable(b,'Sheet','Sheet1','Range','S2:U16');
Data.K000_P30_L_2 = zeros(37,3);
Data.K000_P30_L_2 = readtable(b,'Sheet','Sheet1','Range','V2:X38');
Data.K000_P30_L_3 = zeros(28,3);
Data.K000_P30_L_3 = readtable(b,'Sheet','Sheet1','Range','Y2:AA29');


Data.K030_000_L_1 = zeros(29,3);
Data.K030_000_L_1 = readtable(b,'Sheet','Sheet1','Range','A40:C65');
Data.K030_000_L_2 = zeros(27,3);
Data.K030_000_L_2 = readtable(b,'Sheet','Sheet1','Range','D40:F66');
Data.K030_000_L_3 = zeros(28,3);
Data.K030_000_L_3 = readtable(b,'Sheet','Sheet1','Range','G40:I65');

Data.K030_D10_L_1 = zeros(31,3);
Data.K030_D10_L_1 = readtable(b,'Sheet','Sheet1','Range','J40:L70');
Data.K030_D10_L_2 = zeros(29,3);
Data.K030_D10_L_2 = readtable(b,'Sheet','Sheet1','Range','M40:O68');
Data.K030_D10_L_3 = zeros(29,3);
Data.K030_D10_L_3 = readtable(b,'Sheet','Sheet1','Range','P40:R68');

Data.K030_P30_L_1 = zeros(21,3);
Data.K030_P30_L_1 = readtable(b,'Sheet','Sheet1','Range','S40:U60');
Data.K030_P30_L_2 = zeros(22,3);
Data.K030_P30_L_2 = readtable(b,'Sheet','Sheet1','Range','V40:X61');
Data.K030_P30_L_3 = zeros(22,3);
Data.K030_P30_L_3 = readtable(b,'Sheet','Sheet1','Range','Y40:AA61');


Data.K060_000_L_1 = zeros(26,3);
Data.K060_000_L_1 = readtable(b,'Sheet','Sheet1','Range','A72:C97');
Data.K060_000_L_2 = zeros(22,3);
Data.K060_000_L_2 = readtable(b,'Sheet','Sheet1','Range','D72:F93');
Data.K060_000_L_3 = zeros(23,3);
Data.K060_000_L_3 = readtable(b,'Sheet','Sheet1','Range','G72:I94');

Data.K060_D10_L_1 = zeros(21,3);
Data.K060_D10_L_1 = readtable(b,'Sheet','Sheet1','Range','J72:L92');
Data.K060_D10_L_2 = zeros(20,3);
Data.K060_D10_L_2 = readtable(b,'Sheet','Sheet1','Range','M72:O91');
Data.K060_D10_L_3 = zeros(22,3);
Data.K060_D10_L_3 = readtable(b,'Sheet','Sheet1','Range','P72:R93');

Data.K060_P30_L_1 = zeros(22,3);
Data.K060_P30_L_1 = readtable(b,'Sheet','Sheet1','Range','S72:U93');
Data.K060_P30_L_2 = zeros(21,3);
Data.K060_P30_L_2 = readtable(b,'Sheet','Sheet1','Range','V72:X92');
Data.K060_P30_L_3 = zeros(21,3);
Data.K060_P30_L_3 = readtable(b,'Sheet','Sheet1','Range','Y72:AA92');


Data.K090_000_L_1 = zeros(16,3);
Data.K090_000_L_1 = readtable(b,'Sheet','Sheet1','Range','A99:C114');
Data.K090_000_L_2 = zeros(25,3);
Data.K090_000_L_2 = readtable(b,'Sheet','Sheet1','Range','D99:F123');
Data.K090_000_L_3 = zeros(19,3);
Data.K090_000_L_3 = readtable(b,'Sheet','Sheet1','Range','G99:I117');

Data.K090_D10_L_1 = zeros(19,3);
Data.K090_D10_L_1 = readtable(b,'Sheet','Sheet1','Range','J99:L117');
Data.K090_D10_L_2 = zeros(14,3);
Data.K090_D10_L_2 = readtable(b,'Sheet','Sheet1','Range','M99:O112');
Data.K090_D10_L_3 = zeros(20,3);
Data.K090_D10_L_3 = readtable(b,'Sheet','Sheet1','Range','P99:R118');

Data.K090_P30_L_1 = zeros(22,3);
Data.K090_P30_L_1 = readtable(b,'Sheet','Sheet1','Range','S99:U120');
Data.K090_P30_L_2 = zeros(22,3);
Data.K090_P30_L_2 = readtable(b,'Sheet','Sheet1','Range','V99:X120');
Data.K090_P30_L_3 = zeros(20,3);
Data.K090_P30_L_3 = readtable(b,'Sheet','Sheet1','Range','Y99:AA118');


Data.K110_000_L_1 = zeros(12,3);
Data.K110_000_L_1 = readtable(b,'Sheet','Sheet1','Range','A125:C136');
Data.K110_000_L_2 = zeros(15,3);
Data.K110_000_L_2 = readtable(b,'Sheet','Sheet1','Range','D125:F139');
Data.K110_000_L_3 = zeros(13,3);
Data.K110_000_L_3 = readtable(b,'Sheet','Sheet1','Range','G125:I137');

Data.K110_D10_L_1 = zeros(14,3);
Data.K110_D10_L_1 = readtable(b,'Sheet','Sheet1','Range','J125:L138');
Data.K110_D10_L_2 = zeros(12,3);
Data.K110_D10_L_2 = readtable(b,'Sheet','Sheet1','Range','M125:O136');
Data.K110_D10_L_3 = zeros(14,3);
Data.K110_D10_L_3 = readtable(b,'Sheet','Sheet1','Range','P125:R138');

Data.K110_P30_L_1 = zeros(14,3);
Data.K110_P30_L_1 = readtable(b,'Sheet','Sheet1','Range','S125:U138');
Data.K110_P30_L_2 = zeros(15,3);
Data.K110_P30_L_2 = readtable(b,'Sheet','Sheet1','Range','V125:X139');
Data.K110_P30_L_3 = zeros(18,3);
Data.K110_P30_L_3 = readtable(b,'Sheet','Sheet1','Range','Y125:AA142');


%  folowing line commented because trial K0-0-L-1 is bad
% Lateral0 = vertcat(Data.K000_000_L_1, Data.K000_000_L_2, Data.K000_000_L_3, Data.K000_D10_L_1, Data.K000_D10_L_2, Data.K000_D10_L_3, Data.K000_P30_L_1, Data.K000_P30_L_2, Data.K000_P30_L_3);
% Lateral0      = vertcat(Data.K000_000_L_1,Data.K000_000_L_2, Data.K000_000_L_3);
Data.Lateral0      = vertcat(Data.K000_000_L_2, Data.K000_000_L_3);
Data.Lateral0D10   = vertcat(Data.K000_D10_L_1, Data.K000_D10_L_2, Data.K000_D10_L_3);
Data.Lateral0P30   = vertcat(Data.K000_P30_L_1, Data.K000_P30_L_2, Data.K000_P30_L_3);
Data.Lateral30     = vertcat(Data.K030_000_L_1, Data.K030_000_L_2, Data.K030_000_L_3);
Data.Lateral30D10  = vertcat(Data.K030_D10_L_1, Data.K030_D10_L_2, Data.K030_D10_L_3);
Data.Lateral30P30  = vertcat(Data.K030_P30_L_1, Data.K030_P30_L_2, Data.K030_P30_L_3);
Data.Lateral60     = vertcat(Data.K060_000_L_1, Data.K060_000_L_2, Data.K060_000_L_3);
Data.Lateral60D10  = vertcat(Data.K060_D10_L_1, Data.K060_D10_L_2, Data.K060_D10_L_3);
Data.Lateral60P30  = vertcat(Data.K060_P30_L_1, Data.K060_P30_L_2, Data.K060_P30_L_3);
Data.Lateral90     = vertcat(Data.K090_000_L_1, Data.K090_000_L_2, Data.K090_000_L_3);
Data.Lateral90D10  = vertcat(Data.K090_D10_L_1, Data.K090_D10_L_2, Data.K090_D10_L_3);
Data.Lateral90P30  = vertcat(Data.K090_P30_L_1, Data.K090_P30_L_2, Data.K090_P30_L_3);
Data.Lateral110    = vertcat(Data.K110_000_L_1, Data.K110_000_L_2, Data.K110_000_L_3);
Data.Lateral110D10 = vertcat(Data.K110_D10_L_1, Data.K110_D10_L_2, Data.K110_D10_L_3);
Data.Lateral110P30 = vertcat(Data.K110_P30_L_1, Data.K110_P30_L_2, Data.K110_P30_L_3);

trial = {'0','0D10','0P30','30','30D10','30P30','60','60D10','60P30','90','90D10','90P30','110','110D10','110P30'};



for y = 1:15


[s, o] = sortrows(Data.(strcat("Lateral",trial{y}))(:,2));
% Following two lines commented because they chnage the quadrant that the
% data is in
s.Var2 = -1 * s.Var2;
Data.(strcat("Lateral",trial{y})){:,1} = -1 * Data.(strcat("Lateral",trial{y})){:,1};
Data.(strcat("Laterals",trial{y})) = [Data.(strcat("Lateral",trial{y})){o,1}, s.Var2, Data.(strcat("Lateral",trial{y})){o,3}];
L = length(Data.(strcat("Laterals",trial{y})));

latfit = polyfit(Data.(strcat("Laterals",trial{y}))(:,2),Data.(strcat("Laterals",trial{y}))(:,1), 3);

poly = latfit(1)*Data.(strcat("Laterals",trial{y}))(:,2).^3 + latfit(2)*Data.(strcat("Laterals",trial{y}))(:,2).^2 + latfit(3)*Data.(strcat("Laterals",trial{y}))(:,2).^1 + latfit(4);
%y' = 3ax^2 + 2bx + c
%y'' = 6ax+ 2b
%x = (-2b)/(6a)
%val = polyval(poly,x)
% lbx = Laterals0(1,2); changed so tht the lower bound is what the upper
% bound would normally be so that the wraping object better fits distal data points
ubx = (-2*latfit(2))/(6*latfit(1));
lbx = (-2*latfit(2))/(6*latfit(1));
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

