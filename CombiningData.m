function CombiningData(filedata)
Basepath=filedata.Basepath;
load([Basepath '\US_raw.mat']);
Knee=filedata.Knee;
Ankle=filedata.Ankle;
Trial=filedata.Trial;
Subject=filedata.Subject;
filedata.trial=[];
for S=1:length(Subject)
    Mocadir = append(Basepath,'\Moca\',Subject(S),'\');
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                us=Data.(Subject(S)).(fname).data;
                if ~isempty(us)
                    Moca_datadir=append(Mocadir,fname,"_IK.mot");
                    if isfile(Moca_datadir)
                        Moca_data=importdata(Moca_datadir);
                        [r_Moca_data,c_Moca_data]=find(strncmp(Moca_data.colheaders,'CLine_t',7));
                        Moca_data_trimed=Moca_data.data(:,c_Moca_data);
                        %%% finding the end time
                        if us(end,1)> Moca_data.data(end,1)
                            indx=find(us(:,1) <= Moca_data.data(end,1));
                        else
                            indx=1:length(us(:,1));
                        end
                        Moca_data_interpolated = interp1(Moca_data.data(:,1),Moca_data.data,us(indx,1),'linear','extrap');
                        us_x = 1*((us(indx,2) - 72.72)/1000);
                        us_y = 1*((us(indx,3) - 9.28)/1000);
                        Moca_data_interpolated(:,c_Moca_data([1,3]))=[us_x,us_y];
                        combined_Data=Moca_data_interpolated;
                        F_fnames = append(fname,'_Combined.mot');
                        Datafolder = append(Mocadir);
                        delimiterIn = '\t';
                        Dataheadermotion=[{"time"} Moca_data.colheaders];
                        Title='version=1\nnRows=%d\nnColumns=%d\ninDegrees=yes\nendheader\n';
                        [r,c] = size(combined_Data);
                        Titledata = [r,c];
                        MDatadata = combined_Data;
                        makefile(Datafolder,F_fnames,Title,Titledata,Moca_data.colheaders,MDatadata,5,delimiterIn);
                        disp(append(Subject(S),"_",F_fnames))
                    else
                        fprintf('Ik data for  %s_%s does not exist \n',Subject(S),fname);
                    end
                else
                    fprintf('Ultrasound data for  %s_%s does not exist \n',Subject(S),fname);
                end
            end
        end
    end
end
end





