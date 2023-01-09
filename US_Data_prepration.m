function US_Data_prepration(filedata)
%composite file with pathway coordinates
Basepath=filedata.Basepath;
% Data format [Frame X Y]
filedata.trialslable=[];
MuscleName="Lateral";
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
% Knee0 = ["K000","K030","K060","K090","K110"];
Subject=[];
Knee=[];
for S=1:length(filedata.trialas) 
    trial_name=char(filedata.trialas(S));
    indxuderline=strfind(trial_name,'_');
    s=trial_name(1:indxuderline(1)-1);
    Subject=addfun(Subject,s);
    kn=trial_name(indxuderline(1)+1:indxuderline(2)-1);
    Knee=addfun(Knee,kn);
end
% end
for S=1:length(Subject)
   US_path=append(Basepath,'\US\',Subject(S),'.xlsx');
     for K=1:length(Knee)
        Us_Data_cell=readcell(US_path,'Sheet',Knee(K));
        [rs,cs]=size(Us_Data_cell);
        [r,c]=find(strcmp(Us_Data_cell,'Frame'));
        [r_fps,c_fps]=find(strcmp(Us_Data_cell,'FPS'));
        [r_x,c_x]=find(strcmp(Us_Data_cell,'X'));
        if length(r)~=9
            warning('Some trial of %s_%s has been lost',Subject(S),Knee(K))
        end
        Us_Data_size=[rs-r(1),4];
        counter=0;
        for A=1:length(Ankle)
            for T=1:length(Trial)
                
                counter=counter+1;
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                
                Fps=[Us_Data_cell{r_fps(counter),c_fps(counter)+1}];
                Data.(Subject(S)).(fname).FPS=Fps;
                Us_Data_cell_trimed=[Us_Data_cell{[r(counter)+1:rs],[c(counter):c(counter)+Us_Data_size(2)-1]}];
                Us_Data_cell_trimed_reshaped=reshape(Us_Data_cell_trimed,Us_Data_size);
                
                Us_Data_Mat= rmmissing(Us_Data_cell_trimed_reshaped(:,[1,3,4]));
                if ~isempty(Us_Data_Mat)
                    Data.(Subject(S)).(fname).data=[Us_Data_Mat(:,1)./Fps Us_Data_Mat(:,[2,3])] ;
                else
                    Data.(Subject(S)).(fname).data=[];
                end
            end
        end
     end
        
    
    fprintf('US process of %s is done\n',Subject(S));

end
fprintf('US_raw.mat is save in %s \n',Basepath);
save([Basepath '\US_raw.mat'],'Data');
end