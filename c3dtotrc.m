function c3dtotrc (filedata)
Basepath=filedata.Basepath;
load([Basepath '\US_raw.mat']);
% Knee=filedata.Knee;
% Ankle=filedata.Ankle;
% Trial=filedata.Trial;
% Subject=filedata.Subject;
filedata.trial=[];
newFPS=20;
RMatrix=[0 0 1; ...
    1 0 0; ...
    0 1 0];

for S=1:length(filedata.trialas) 
            trial_name=char(filedata.trialas(S));
            indxuderline=strfind(trial_name,'_');
            Subject=trial_name(1:indxuderline(1)-1);
            fname=erase(trial_name,append(Subject,"_"));
            Trc_path=append(filedata.Basepath,'\Moca\',Subject,'\');
%             fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            fullname=filedata.trialas(S);
            filedir=char(fullfile(Trc_path,append(fname,".c3d")));
            if isfile(filedir)
            markdatastruct = c3d_getdata(filedir, 0);
            oldFPS=markdatastruct.marker_data.Info.frequency;
            jupdata=oldFPS/newFPS;
            Markerset=fieldnames(markdatastruct.marker_data.Markers);
            Markerset=Markerset(~contains(Markerset,'C_'));
            % checking if US5 and US 4 is swapped 
            if (contains(Markerset,"US5")&contains(Markerset,"US4"))
                markdatastruct=marker_check(markdatastruct);
            end
           MarkerData=[];
           MarkerDatare=[];
           rm=length(Markerset);
           Markersetnew=Markerset;
           [endtimeindx,cc]=size(markdatastruct.marker_data.Markers.(Markerset{1}));
            for i = 1:rm
                RawMarker=markdatastruct.marker_data.Markers.(Markerset{i})*RMatrix;
                zeronumbers=find(RawMarker==0);
                if zeronumbers>1
                    endtimeindx=min(zeronumbers(1)-1,endtimeindx);
                end
                if isempty(zeronumbers) zeronumbers=0; end 
                if zeronumbers(1)~=1
                    [bb,aa] = butter(2, 0.05,'low');
                    MarerDatafilt=filtfilt(bb,aa,RawMarker);
                    MarkerData =[MarkerData MarerDatafilt];
                else
                    MarkerDatare=[MarkerDatare string(Markerset{i})];
                    fprintf('Warning: %s has removed from %s \n',string(Markerset{i}),fullname);
                    Markersetnew=Markerset(~contains(Markerset,MarkerDatare));
                end
            end
            markerinfo=markdatastruct.marker_data.Info;
            frames_oldFPS=markerinfo.First_Frame:markerinfo.Last_Frame;
            time_oldFPS=frames_oldFPS/oldFPS;
            endframe_oldFPS=frames_oldFPS(endtimeindx);
            Etime=time_oldFPS(endtimeindx);
            Stime=time_oldFPS(1);
            time_newFPS=Stime:1/newFPS:Etime;
            MarkerData_newFPS=interp1(time_oldFPS,MarkerData,time_newFPS,'linear');
            numofUSmarker=sum(contains(Markersetnew,"US"));
            writeflage=1;
            if numofUSmarker<3
                fprintf('Warning: %s has less than 3 markers for US prob n',fullname);
                writeflage=0;
            end
            [r,c]=size(MarkerData_newFPS);
   
            markdatastruct.marker_data.Info.frequency=newFPS;
            if markdatastruct.marker_data.Info.First_Frame>1
             fprintf('Warning: First frame of %s changed to 1 \n',fullname);
            end
            


            markdatastruct.marker_data.Time= time_newFPS;
            MarkerData_newFPS=[time_newFPS' MarkerData_newFPS];
            markerinfo.Last_Frame=r;
            markerinfo.First_Frame=1;
            markerinfo.NumFrames=markerinfo.Last_Frame-markerinfo.First_Frame;
            markerinfo.Filename=erase(markerinfo.Filename,'_edited');
            generate_Marker_Trc(Markersetnew,MarkerData_newFPS,markerinfo);
            else
                 fprintf('Warning: C3d file of %s was not found \n',fullname);
            end

end
end