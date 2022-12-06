clear all
import org.opensim.modeling.*;
myLog = JavaLogSink();
Logger.addSink(myLog);
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
load([Basepath '\US_raw.mat']);
Trc_path=append(Basepath,'\Moca\');
subject=["p7"];
Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
Data.trial=[];
for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
            motiondir=append(Trc_path,subject,"\");
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
            us=Data.(fname).data;
            model=Model(append(Trc_path,subject,"\","exp19_p7_raj.osim"));
            analysis = AnalyzeTool();           
            motion = Storage(append(motiondir,fname,'_Combined.mot'));
            analysis.setName(fname);
            analysis.setModel(model);
            analysis.setModelFilename("p7/exp19_p7_raj.osim");
            analysis.setCoordinatesFileName(append(motiondir,fname,'_Combined.mot'));             
            analysis.setInitialTime(motion.getFirstTime());
            analysis.setFinalTime(motion.getLastTime());
            analysis.setResultsDir(append(Trc_path,"..\Mucle_Center\",fname,"_MuscleCenter"));
            endkinematic=PointKinematics(model);
            endkinematic.setBody(model.getBodySet.get('Muscle_C'));
            endkinematic.setRelativeToBody(model.getBodySet.get('tibia_l'))
            endkinematic.setPointName('MUCE');
            endkinematic.setPoint(Vec3(0,0,0))
            endkinematic.setStartTime(motion.getFirstTime())
            endkinematic.setEndTime(motion.getLastTime())
            analysis.updAnalysisSet().adoptAndAppend(endkinematic());
            analysis.print(append(Trc_path,"Analyze_Setup.xml"));
            analysis1 = AnalyzeTool(append(Trc_path,"Analyze_Setup.xml"));
            analysis1.run();
        end
    end
end