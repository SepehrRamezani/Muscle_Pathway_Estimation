
close all
clear all
%composite file with pathway coordinates
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
US_path=append(Basepath,'\US\Experiment19(P7).xlsx');
x = -1.5:0.01:3.5;
y = sqrt(6-(x-1).^2)-2;
yr = y+rand(1,length(y));
xr = x+rand(1,length(x));
% Data format [Frame X Y]
Knee0 = ["K000","K030","K060","K090","K110"];
Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
Data.trials=[];
MuscleName="Lateral";
for K=1:length(Knee)
    Us_Data_cell=readcell(US_path,'Sheet',Knee0(K));
    [rs,cs]=size(Us_Data_cell);
    [r,c]=find(strcmp(Us_Data_cell,'Frame'));
    if length(r)~=9
        warning('Some trial has been lost')
    end
    Us_Data_size=[rs-r(1),4];
    counter=0;
    for A=1:length(Ankle)
        for T=1:length(Trial)
            
            counter=counter+1;
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            [r_fps,c_fps]=find(strcmp(Us_Data_cell,'FPS'));
            Data.(fname).FPS=[Us_Data_cell{r_fps(counter),c_fps(counter)+1}];
            Us_Data_cell_trimed=[Us_Data_cell{[r(1)+1:rs],[c(counter):c(counter)+Us_Data_size(2)-1]}];
            Us_Data_cell_trimed_reshaped=reshape(Us_Data_cell_trimed,Us_Data_size);
            Us_Data_Mat= rmmissing(Us_Data_cell_trimed_reshaped);
            Data.(fname).data=[Us_Data_Mat(:,1)./Data.(fname).FPS Us_Data_Mat(:,[2,3])] ;
            Datalabel=append(MuscleName,"_",Knee(K),"_",Ankle(A),"_L_",Trial(T));
            Data.trials=[Data.trials, Datalabel];
        end
    end
end
save([Basepath '\US_raw.mat'],'Data');