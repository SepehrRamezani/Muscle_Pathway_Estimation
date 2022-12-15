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
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            us=Data.(fname).data;
            model=Model(append(Trc_path,Subject,"_raj.osim"));
            ikTool=InverseKinematicsTool(append(Trc_path,'..\IK_Setup1.xml'));
            ikTool.setModel(model);
            ikTool.setMarkerDataFileName(append(Trc_path,fname,"_Marker.trc"));
            ikTool.setStartTime(us(1,1));
            ikTool.setEndTime(us(1,end));
            ikTool.setOutputMotionFileName(append(Trc_path,fname,"_IK.mot"));     
            ikTool.print(append(Trc_path,"..\IK_Setup.xml"));
            ikTool.run();

        end
    end
end
end
end