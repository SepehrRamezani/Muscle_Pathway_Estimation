% input trc out mot
clear all
import org.opensim.modeling.*;
myLog = JavaLogSink();
Logger.addSink(myLog);
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
Trc_path=append(Basepath,'\Moca\p7\');
Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
Data.trial=[];
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            filename=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            model=Model(append(Trc_path,"exp19_p7_raj.osim"));
            ikTool=InverseKinematicsTool(append(Trc_path,"..\ScalingSetup.xml")); % to read xml file for IK
            ikTool.setModel(model);
            ikTool.setMarkerDataFileName(append(Trc_path,filename,"_Marker.trc"));
            ikTool.setOutputMotionFileName(append(Trc_path,filename,"_IK.mot"));
            ikTool.run();

        end
    end
end