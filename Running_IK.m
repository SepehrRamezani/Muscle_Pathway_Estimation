function Running_IK(filedata)
import org.opensim.modeling.*;
Basepath=filedata.Basepath;
load([Basepath '\US_raw.mat']);
Knee=filedata.Knee;
Ankle=filedata.Ankle;
Trial=filedata.Trial;
Subject=filedata.Subject;
filedata.trial=[];
for S=1:length(Subject)
    Trc_path=append(filedata.Basepath,'\Moca\',Subject(S),'\');
    model=Model(append(Trc_path,Subject(S),"_raj_modified.osim"));
    model.getCoordinateSet().get('CLine_tx').set_locked(true);
    model.getCoordinateSet().get('CLine_tz').set_locked(true);
    model.initSystem();
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                fullname=append(Subject(S),"_",fname);
                markerdir=append(Trc_path,fname,"_Marker.trc");
                if isfile(markerdir)
                    motion = MarkerData(markerdir);
                    %             motiont=motion.exportToTable();
                    MarkerNameset=motion.getMarkerNames();
                    MarkerNames=[];
                    for j=0:MarkerNameset.getSize()-1
                        MarkerNames=[MarkerNames string(MarkerNameset.get(j))];
                    end
                    %             us=Data.(fname).data;
                    
                    ikTool=InverseKinematicsTool(append(Trc_path,'..\IK_Setup1.xml'));
                    Tskset=ikTool.getIKTaskSet();
                    for i=0:Tskset.getSize()-1
                        Task=ikTool.getIKTaskSet().get(i);
                        if ~sum(contains(MarkerNames,string(Task.getName())))
                            Task.setApply(false)
                            fprintf('%s does not have %s \n',fullname,string(Task.getName()));
                        end
                        
                    end
                    ikTool.setName(fname)
                    ikTool.setModel(model);
                    ikTool.setResultsDir(Trc_path)
                    %             ikTool.set_report_marker_locations(true);
                    ikTool.setMarkerDataFileName(append(Trc_path,fname,"_Marker.trc"));
                    ikTool.setStartTime(motion.getStartFrameTime());
                    ikTool.setEndTime(motion.getLastFrameTime());
                    outdir=append(Trc_path,fname,"_IK.mot");
                    ikTool.setOutputMotionFileName(outdir);
                    ikTool.print(append(Trc_path,"..\IK_Setup.xml"));
                    ikTool.run();
                    fprintf('IK of %s is done\n',fullname);
                    ik_marker_Error_file = strrep(outdir, 'IK.mot', 'ik_marker_errors.sto');
                    ik_marker_Error=importdata(ik_marker_Error_file);
                    marker_error_RMS=mean(ik_marker_Error.data(:,3));
                    if marker_error_RMS >= 0.02
                        fprintf('Warning: Average marker_error_RMS of %s is %3.4f \n',fullname,marker_error_RMS);
                        BadIKData.name=append(Subject(S),'_',fname);
                        BadIKData.data=marker_error_RMS;
                    end
                else
                    fprintf('Warning: trc file of %s was not found \n',fullname);
                end
                %             Data.(Subject(S)).(fname).MarkerError=marker_error_RMS;
            end
        end
    end
end
save([Basepath '\BadIK.mat'],'BadIKData');
end