function c3dtotrc (filedata)
Basepath=filedata.Basepath;
load([Basepath '\US_raw.mat']);
Knee=filedata.Knee;
Ankle=filedata.Ankle;
Trial=filedata.Trial;
Subject=filedata.Subject;
filedata.trial=[];
newFPS=20;
RMatrix=[0 0 1; ...
    1 0 0; ...
    0 1 0];

for S=1:length(Subject) 
    Trc_path=append(filedata.Basepath,'\Moca\',Subject(S),'\');
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            filedir=char(fullfile(Trc_path,append(fname,".c3d")));
            if isfile(filedir)
            markdatastruct = c3d_getdata(filedir, 0);
            jupdata=markdatastruct.marker_data.Info.frequency/newFPS;
            Markerset=fieldnames(markdatastruct.marker_data.Markers);
            Markerset=Markerset(~contains(Markerset,'C_'));
            if (contains(Markerset,"US5")&contains(Markerset,"US4"))
                markdatastruct=marker_check(markdatastruct);
            end
           MarkerData=[];
            for i = 1:length(Markerset)
                RawMarker=markdatastruct.marker_data.Markers.(Markerset{i})*RMatrix;
                [bb,aa] = butter(2, 0.05,'low');
                MarerDatafilt=filtfilt(bb,aa,RawMarker);
                MarkerData =[MarkerData MarerDatafilt(1:jupdata:end,:)];
            end
            [r,c]=size(MarkerData);
            oldFPS=markdatastruct.marker_data.Info.frequency;
            markdatastruct.marker_data.Info.frequency=newFPS;
            if markdatastruct.marker_data.Info.First_Frame>1
             fprintf('Warning: First Time frmae of %s_%s is not 1 \n',Subject(S),fname);
            end
            markerinfo=markdatastruct.marker_data.Info;
            markdatastruct.marker_data.Time= [markerinfo.First_Frame/oldFPS:(1/newFPS):markerinfo.Last_Frame/oldFPS]';
            MarkerData=[markdatastruct.marker_data.Time MarkerData];
            markerinfo.Last_Frame=r;
            markerinfo.First_Frame=1;
            markerinfo.NumFrames=markerinfo.Last_Frame-markerinfo.First_Frame;
            markerinfo.Filename=erase(markerinfo.Filename,'_edited');
            generate_Marker_Trc(Markerset,MarkerData,markerinfo);
            else
                 fprintf('Warning: C3d file of %s_%s was not found \n',Subject(S),fname);
            end
        end
    end
end
end
end