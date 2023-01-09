 function [MCPData] = Momentarm_Calculator(filedata)
Basepath=filedata.Basepath;
import org.opensim.modeling.*;
load([Basepath '\MCP_data.mat']);
fcoboname=filedata.fcoboname;
Model_path="";
for S=1:length(fcoboname)
    trial_name=char(fcoboname(S));
    indxuderline=strfind(trial_name,'_');
    Subject=trial_name(1:indxuderline(1)-1);
    Model_path_new=append(Basepath,'\Moca\',Subject,"\",Subject,"_raj.osim");
    Knee=string(trial_name(indxuderline(1)+1:indxuderline(2)-1));
    Ankle=string(trial_name(indxuderline(2)+1:end));
    if ~contains(Model_path,Model_path_new)
        Model_path=Model_path_new;
        model=Model(Model_path);
    end
 
            Wrapping_param=MCPData.(fcoboname(S)).WrappingPar;
            wrap_r=Wrapping_param(1);
%           Be aware of OpenSim axis
%           Opensim y -> code -x
%           Opensim x -> code -y
            wrap_y=-1*Wrapping_param(2);
            wrap_x=-1*Wrapping_param(3);
            Curbody=model.getBodySet.get('tibia_l');
            
            Wrapobj=Curbody.getWrapObjectSet().get('GasLat_at_shank_l');
            CylinderWrapobj=WrapCylinder.safeDownCast(Wrapobj);
            CylinderWrapobj.set_radius(wrap_r);
            wrap_z=CylinderWrapobj.get_translation().get(2);
            CylinderWrapobj.set_translation(Vec3(wrap_x,wrap_y,wrap_z));
            model.initSystem();
            kneeangle= double(erase(Knee,"K"));
            if contains(Ankle,"P")
                ankleangle=-1*double(erase(Ankle,"P"));
            else
                ankleangle=1*double(erase(Ankle,"D"));
            end
            
            Musclename='gaslat_l';
            kneecoord='knee_angle_l';
            anklecoord='ankle_angle_l';
            state = model.initSystem();
            force = model.getForceSet().get(Musclename);
            muscle = Millard2012EquilibriumMuscle.safeDownCast(force);
            kneecoord=model.updCoordinateSet().get(kneecoord);
            kneecoord.setValue(state, kneeangle);
            model.updCoordinateSet().get(anklecoord).setValue(state, ankleangle);
            model.realizePosition(state);
            Momentarm = muscle.computeMomentArm(state, kneecoord);
            MCPData.(fcoboname(S)).Momentarm=Momentarm;
    
end
save([Basepath '\MomentArm_data.mat'],'MCPData');
end