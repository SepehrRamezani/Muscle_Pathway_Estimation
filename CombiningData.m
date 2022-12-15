function CombiningData(refData)
Basepath=refData.Basepath;
load([Basepath '\US_raw.mat']);
Knee=refData.Knee;
Ankle=refData.Ankle;
Trial=refData.Trial;
Subject=refData.Subject;
refData.trial=[];
for S=1:length(Subject)
    Mocadir = append(Basepath,'\Moca\',Subject,'\');
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
                
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                
                us=Data.(fname).data;
                Moca_data=importdata(append(Mocadir,fname,"_IK.mot"));
                [r_us_coordinate,c_Moca_data]=find(strncmp(Moca_data.colheaders,'CLine_t',7));
                % Moca_data_trimed=Moca_data.data(:,c_Moca_data);
                Moca_data_interpolated = interp1(Moca_data.data(:,1),Moca_data.data,us(:,1),'linear','extrap');
                us_x = 1* ((us(:,2) - 72.72)/1000); %had -156.2 before /1000
                us_y = 1*((us(:,3) - 9.28)/1000); %had  -14.2 before /1000
                Moca_data_interpolated(:,c_Moca_data([1,3]))=[us_x,us_y];
                combined_Data=Moca_data_interpolated;
                F_fnames = append(fname,'_Combined.mot');
                Datafolder = append(Mocadir);
                delimiterIn = '\t';
%                 Dataheadermotion=[{"time"} Moca_data.colheaders];
                Title='version=1\nnRows=%d\nnColumns=%d\ninDegrees=yes\nendheader\n';
                [r,c] = size(combined_Data);
                Titledata = [r,c];
                MDatadata = combined_Data;
                makefile(Datafolder,F_fnames,Title,Titledata,Moca_data.colheaders,MDatadata,5,delimiterIn);
                disp(F_fnames)
            end
        end
    end
end
end





