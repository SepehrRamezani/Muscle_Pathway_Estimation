clc, clearvars, clear 
close all
%composite file with pathway coordinates
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
US_path=append(Basepath,'\Experiment19(P7).xlsx');
x = -1.5:0.01:3.5;
y = sqrt(6-(x-1).^2)-2;
yr = y+rand(1,length(y));
xr = x+rand(1,length(x));
% Data format [Frame X Y]
Knee = ["K000","K030","K060","K090","K110"];
Ankle = ["000","D10","P30"];
Trial = ["1","2","3"];
Data.trial=[];
MuscleName="Lateral";
for K=1:length(Knee)
    Us_Data_cell=readcell(US_path,'Sheet',Knee(K));
    [rs,cs]=size(Us_Data_cell);
    [r,c]=find(strcmp(Us_Data_cell,'X'));
    if length(r)~=9
        warning('Some trial has been lost')
    end
    Us_Data_size=[rs-r(1),2];
    counter=0;
    for A=1:length(Ankle)
        CombinedData=[];
        for T=1:length(Trial)
             counter=counter+1;
            Us_Data_cell_trimed=[Us_Data_cell{[r(1)+1:rs],[c(counter):c(counter)+1]}];
            Us_Data_cell_trimed_reshaped=reshape(Us_Data_cell_trimed,Us_Data_size);
            Us_Data_Mat= rmmissing(Us_Data_cell_trimed_reshaped);
            Data.(append(Knee(K),"_",Ankle(A),"_L_",Trial(T)))=Us_Data_Mat;
            CombinedData=[CombinedData;Us_Data_Mat];
        end
        combinedlabel=append(MuscleName,Knee(K),"_",Ankle(A));
        Data.(combinedlabel)=CombinedData;
        Data.trial=[Data.trial, combinedlabel];
    end
end
save([Basepath '\US_raw.mat'],'Data');