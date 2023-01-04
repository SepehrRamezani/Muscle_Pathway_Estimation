 function [MCPData] = Momentarm_Calculator(filedata)
Basepath=filedata.Basepath;
import org.opensim.modeling.*;
load([Basepath '\MCP_data.mat']);
Ankle=filedata.Ankle;
Knee=filedata.Knee;
Subject=filedata.Subject;
for S=1:length(Subject)
    Model_path=append(Basepath,'\Moca\',Subject(S),"\",Subject(S),"_raj.osim");
    model=Model(Model_path);
    for K=1:length(Knee)
        for A=1:length(Ankle)
            fcoboname=append(Knee(K),"_",Ankle(A));
            Wrapping_param=MCPData.Subject(S).(fcoboname).WrappingPar;
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
            kneeangle= double(erase(Knee(K),"K"));
            if contains(Ankle(A),"P")
                ankleangle=-1*double(erase(Ankle(A),"P"));
            else
                ankleangle=1*double(erase(Ankle(A),"D"));
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
            MCPData.Subject(S).(fcoboname).Momentarm=Momentarm;
        end
    end
end
save([Basepath '\MomentArm_data.mat'],'MCPData');
end