function Running_IK(Data)
import org.opensim.modeling.*;
Basepath=Data.Basepath;
load([Basepath '\US_raw.mat']);
Knee=Data.Knee;
Ankle=Data.Ankle;
Trial=Data.Trial;
Subject=Data.Subject;
Data.trial=[];
for S=1:length(Subject) 
    Trc_path=append(Data.Basepath,'\Moca\',Subject,'\');
    model=Model(append(Trc_path,Subject,"_raj_modified.osim"));
    model.getCoordinateSet().get('CLine_tx').set_locked(true);
    model.getCoordinateSet().get('CLine_tz').set_locked(true);
    model.initSystem();
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            motion = Storage(append(Trc_path,fname,"_Marker.trc"));
%             motiont=motion.exportToTable();
            MarkerNameset=motion.getColumnLabels();
            MarkerNames=[]
            for j=1:3:MarkerNameset.getSize()-1
                
              MarkerNames=[MarkerNames erase(string(MarkerNameset.get(j)),"_x")];  
            end
%             us=Data.(fname).data;
            
            ikTool=InverseKinematicsTool(append(Trc_path,'..\IK_Setup1.xml'));
            Tskset=ikTool.getIKTaskSet();
            for i=0:Tskset.getSize()-1
                Task=ikTool.getIKTaskSet().get(i);
                if ~sum(contains(MarkerNames,string(Task.getName())))
                    Task.setApply(false)
                    fprintf('%s does not have %s \n',fname,string(Task.getName()));
                end
                
            end
            ikTool.setModel(model);
            ikTool.setMarkerDataFileName(append(Trc_path,fname,"_Marker.trc"));
            ikTool.setStartTime(motion.getFirstTime ());
            ikTool.setEndTime(motion.getLastTime());
            ikTool.setOutputMotionFileName(append(Trc_path,fname,"_IK.mot"));     
            ikTool.print(append(Trc_path,"..\IK_Setup.xml"));
            ikTool.run();

        end
    end
end
end
end