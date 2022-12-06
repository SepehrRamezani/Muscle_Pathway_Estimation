% input trc out mot
clear all
import org.opensim.modeling.*;
myLog = JavaLogSink();
Logger.addSink(myLog);
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
load([Basepath '\US_raw.mat']);
Trc_path=append(Basepath,'\Moca\p7\');
Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
Data.trial=[];
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            us=Data.(fname).data;
            model=Model(append(Trc_path,"exp19_p7_raj.osim"));
            motion = Storage(append(Trc_path,fname,'_IK.mot'));
            ikTool=InverseKinematicsTool(append(Trc_path,'..\IK_Setup1.xml'));
            ikTool.setModel(model);
            ikTool.setMarkerDataFileName(append(Trc_path,fname,"_Marker.trc"));
            ikTool.setStartTime(us(1,1));
            ikTool.setEndTime(us(end,1));
            ikTool.setOutputMotionFileName(append(Trc_path,fname,"_IK.mot"));     
            ikTool.print(append(Trc_path,"..\IK_Setup.xml"));
            ikTool.run();

        end
    end
end