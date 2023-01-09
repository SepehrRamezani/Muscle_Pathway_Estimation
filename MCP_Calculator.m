function MCP_Calculator(filedata)
import org.opensim.modeling.*;
Basepath=filedata.Basepath;
motionbasedir=append(Basepath,'\Moca\');
filedata.trial=[];
for S=1:length(filedata.trialas) 
            trial_name=char(filedata.trialas(S));
            indxuderline=strfind(trial_name,'_');
            Subject=trial_name(1:indxuderline(1)-1);
            fname=erase(trial_name,append(Subject,"_"));
            fullname=filedata.trialas(S);
            Resuletdir=fullfile(Basepath,"Mucle_Center",Subject);
            mkdir(Resuletdir);
            motiondir=append(motionbasedir,Subject,"\");
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
                    fprintf('MCP of %s is done \n',fullname);
                else
                    fprintf('Warning: combined of %s was not found \n',fullname);
                end

end
end