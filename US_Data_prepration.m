function US_Data_prepration(Data)
%composite file with pathway coordinates
Basepath=Data.Basepath;
% Data format [Frame X Y]
Data.trialslable=[];
MuscleName="Lateral";
Knee0 = ["K000","K030","K060","K090","K110"];
Ankle=Data.Ankle;
Knee=Data.Knee;
Trial=Data.Trial;
Subject=Data.Subject;
for S=1:length(Subject)
    US_path=append(Basepath,'\US\',Subject(S),'.xlsx');
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
                Data.(fname).data=[Us_Data_Mat(:,1)./Data.(fname).FPS Us_Data_Mat(:,[3,4])] ;
            end
        end
    end
end
fprintf('US prepration done ...');
save([Basepath '\US_raw.mat'],'Data');
end