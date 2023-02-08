function [MomentarmData] = GenModel_Momentarm_Calculator_extraxction(filedata)
Basepath=filedata.Basepath;
import org.opensim.modeling.*;
% load([Basepath '\MCP_data.mat']);
% load([Basepath '\MomentArm_data.mat']);
fcoboname=filedata.fcoboname;
Model_path="";
% MomentarmData=MCPData;
modelname=["raj","thel"];
for m=1:1:length(modelname)
    for S=1:length(fcoboname)
        trial_name=char(fcoboname(S));
        indxuderline=strfind(trial_name,'_');
        Subject=trial_name(1:indxuderline(1)-1);
        model_folder=fullfile(Basepath,'Moca',Subject);

        Model_path_new=fullfile(model_folder,append(Subject,"_",modelname(m),".osim"));
        Knee=string(trial_name(indxuderline(1)+1:indxuderline(2)-1));
        Ankle=string(trial_name(indxuderline(2)+1:end));
        %     to not import model every time takes the loop
        if ~contains(Model_path,Model_path_new)
            Model_path=Model_path_new;
            model=Model(Model_path);
            [ss,ee]=mkdir(fullfile(model_folder,'WrOptmodel'));
        end

        model.initSystem();
        kneeangle= deg2rad(double(erase(Knee,"K")));
        kneecoord='knee_angle_l';
        anklecoord='ankle_angle_l';
        if contains(Ankle,"P")
            ankleangle=-1*deg2rad(double(erase(Ankle,"P")));
        else
            ankleangle=1*deg2rad(double(erase(Ankle,"D")));
        end
        if contains(modelname(m),"raj")
            Musclename='gaslat_l';
        else
            Musclename='lat_gas_l';
            kneeangle=-kneeangle;
        end


        state = model.initSystem();
        force = model.getMuscles().get(Musclename);
        %         muscle = Millard2012EquilibriumMuscle.safeDownCast(force);
        Kneecoord=model.updCoordinateSet().get(kneecoord);
        Kneecoord.setValue(state, kneeangle);
        Anklecoord=model.updCoordinateSet().get(anklecoord);
        Anklecoord.setValue(state, ankleangle);
        model.realizePosition(state);
        Momentarm = force.computeMomentArm(state, Kneecoord);
        MomentarmData.(modelname(m)).(fcoboname(S)).Momentarm=Momentarm;
        MomentarmData.staticdata(S,m)=Momentarm;
        MomentarmData.staticdatalable(S,m)=append(fcoboname(S),"_",modelname(m));
    end

end
save([Basepath '\Generic_MomentArm_data.mat'],'MomentarmData');
end