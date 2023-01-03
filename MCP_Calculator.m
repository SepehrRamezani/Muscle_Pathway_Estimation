function MCP_Calculator(filedata)
import org.opensim.modeling.*;
Basepath=filedata.Basepath;
motionbasedir=append(Basepath,'\Moca\');
filedata.trial=[];
Knee=filedata.Knee;
Ankle=filedata.Ankle;
Trial=filedata.Trial;
Subject=filedata.Subject;
filedata.trial=[];
for S=1:length(Subject)
    Resuletdir=fullfile(Basepath,"Mucle_Center",Subject(S));
    mkdir(Resuletdir);
    motiondir=append(motionbasedir,Subject(S),"\");
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                modeldir=append(motionbasedir,Subject(S),"\",Subject(S),"_raj_modified.osim");
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
                    analysis.setResultsDir(fullfile(Resuletdir,append(Subject(S),"_",fname,"_MuscleCenter")));
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
                    fprintf('MCP of %s_%s is done \n',Subject(S),fname);
                else
                    fprintf('Warning: combined of %s_%s was not found \n',Subject(S),fname);
                end
            end
        end
    end
end
end