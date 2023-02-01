 function [MomentarmData] = Momentarm_Calculator(filedata)
 
Basepath=filedata.Basepath;
import org.opensim.modeling.*;
load([Basepath '\MCP_data.mat']);
load([Basepath '\MomentArm_data.mat']);
fcoboname=filedata.fcoboname;
Model_path="";
MomentarmData=MCPData;
for S=1:length(fcoboname)
    trial_name=char(fcoboname(S));
    indxuderline=strfind(trial_name,'_');
    Subject=trial_name(1:indxuderline(1)-1);
    model_folder=fullfile(Basepath,'Moca',Subject);
    Model_path_new=fullfile(model_folder,append(Subject,"_raj_modified.osim"));
    Knee=string(trial_name(indxuderline(1)+1:indxuderline(2)-1));
    Ankle=string(trial_name(indxuderline(2)+1:end));
%     to not import model every time takes the loop  
    if ~contains(Model_path,Model_path_new)
        Model_path=Model_path_new;
        model=Model(Model_path);
        [ss,ee]=mkdir(fullfile(model_folder,'WrOptmodel'));
    end
 
            Wrapping_param=MCPData.(fcoboname(S)).WrappingPar;
            wrap_r=Wrapping_param(1);
%           Be aware of OpenSim axis
%           Opensim y -> code -x
%           Opensim x -> code -y
            wrap_y=-1*Wrapping_param(2);
            wrap_x=-1*Wrapping_param(3);
            wrap_z=0;
            state = model.initSystem();
            Curbody=model.getBodySet.get('tibia_l');

            LLMLMarker=model.getMarkerSet.get('LLML');
            LLMLMarker.changeFramePreserveLocation(state,Curbody);
            Dpoint=[LLMLMarker.get_location.get(0) LLMLMarker.get_location.get(1)];
            Cpoint=[wrap_x wrap_y];
            Vec=Dpoint-Cpoint;
            wrap_rz=pi()+atan2(Vec(2),Vec(1));
            if wrap_rz < .05
                fprintf('Possible error in wraps angle of %s \n',fcoboname(S));
            end
            Wrapobj=Curbody.getWrapObjectSet().get('GasLat_at_shank_l');
            CylinderWrapobj=WrapCylinder.safeDownCast(Wrapobj);
            
            CylinderWrapobj.set_radius(wrap_r);
            CylinderWrapobj.set_translation(Vec3(wrap_x,wrap_y,wrap_z));
            CylinderWrapobj.set_xyz_body_rotation(Vec3(0,0,wrap_rz));
            CylinderWrapobj.set_quadrant('y')
            CylinderWrapobj.set_length(0.1);
            CylinderWrapobj.upd_Appearance().set_visible(true);
            model.initSystem();
            kneeangle= deg2rad(double(erase(Knee,"K")));

            if contains(Ankle,"P")
                ankleangle=-1*deg2rad(double(erase(Ankle,"P")));
            else
                ankleangle=1*deg2rad(double(erase(Ankle,"D")));
            end
            
            Musclename='gaslat_l';
            kneecoord='knee_angle_l';
            anklecoord='ankle_angle_l';
            state = model.initSystem();
            force = model.getForceSet().get(Musclename);
            muscle = Millard2012EquilibriumMuscle.safeDownCast(force);
            Kneecoord=model.updCoordinateSet().get(kneecoord);
            Kneecoord.setValue(state, kneeangle);
            Anklecoord=model.updCoordinateSet().get(anklecoord);
            Anklecoord.setValue(state, ankleangle);
            model.realizePosition(state);
            Momentarm = muscle.computeMomentArm(state, Kneecoord);
            Kneecoord.setDefaultValue(kneeangle);
            Anklecoord.setDefaultValue(ankleangle);
            model.setName(append(fcoboname(S),"_raj_Wrp_Opt.osim"));
            model.print(fullfile(model_folder,'WrOptmodel',append(fcoboname(S),"_raj_Wrp_Opt.osim")));
            
            MomentarmData.(fcoboname(S)).Momentarm=Momentarm;
            MomentarmData.staticdata(S,1)=Momentarm;
            MomentarmData.staticdatalable(S,1)=fcoboname(S);
            
end
save([Basepath '\MomentArm_data.mat'],'MomentarmData');
end