function MCP_Calculator(Data)
import org.opensim.modeling.*;
myLog = JavaLogSink();
Logger.addSink(myLog);
Basepath=Data.Basepath;
motionbasedir=append(Basepath,'\Moca\');
Data.trial=[];
Knee=Data.Knee;
Ankle=Data.Ankle;
Trial=Data.Trial;
Subject=Data.Subject;
Data.trial=[];
for S=1:length(Subject)
    motiondir=append(motionbasedir,Subject,"\");
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                model=Model(append(motionbasedir,Subject,"\",Subject,"_raj.osim"));
                analysis = AnalyzeTool();
                motion = Storage(append(motiondir,fname,'_Combined.mot'));
                Stime=motion.getFirstTime();
                Etime=motion.getLastTime();
                analysis.setName(fname);
                analysis.setModel(model);
                analysis.setModelFilename(append(motionbasedir,Subject,"\",Subject,"_raj.osim"));
                analysis.setCoordinatesFileName(append(motiondir,fname,'_Combined.mot'));
                analysis.setInitialTime(Stime);
                analysis.setFinalTime(Etime);
                analysis.setResultsDir(append(motionbasedir,"..\Mucle_Center\",Subject,"\",Subject,"_",fname,"_MuscleCenter"));
                endkinematic=PointKinematics(model);
                endkinematic.setBody(model.getBodySet.get('Muscle_C'));
                endkinematic.setRelativeToBody(model.getBodySet.get('tibia_l'))
                endkinematic.setPointName('MUCE');
                endkinematic.setPoint(Vec3(0,0,0))
                endkinematic.setStartTime(Stime)
                endkinematic.setEndTime(Etime)
                analysis.updAnalysisSet().adoptAndAppend(endkinematic());
                analysis.print(append(motionbasedir,"Analyze_Setup.xml"));
                analysis1 = AnalyzeTool(append(motionbasedir,"Analyze_Setup.xml"));
                analysis1.run();
            end
        end
    end
end
end