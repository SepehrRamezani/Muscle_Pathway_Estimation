function MCP_Calculator(Data)
import org.opensim.modeling.*;
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
                Resuletdir=fullfile(Basepath,"Mucle_Center",Subject);
                mkdir(Resuletdir);
                modeldir=append(motionbasedir,Subject,"\",Subject,"_raj_modified.osim");
                model=Model(modeldir);
                analysis = AnalyzeTool();
                trialdir=append(motiondir,fname,'_Combined.mot');
                if isfile(trialdir)
                    motion = Storage(trialdir);
                    Stime=motion.getFirstTime();
                    Etime=motion.getLastTime();
                    analysis.setName(fname);
                    analysis.setModel(model);
                    analysis.setModelFilename(modeldir);
                    analysis.setCoordinatesFileName(trialdir);
                    analysis.setInitialTime(Stime);
                    analysis.setFinalTime(Etime);
                    analysis.setResultsDir(fullfile(Resuletdir,append(Subject,"_",fname,"_MuscleCenter")));
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
                    fprintf('MCP of %s is done \n',fname);
                else
                    fprintf('%s was not found \n',fname);
                end
            end
        end
    end
end
end