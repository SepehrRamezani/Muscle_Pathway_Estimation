clear all
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
import org.opensim.modeling.*;

% wrapping object optimization
% put in opensim get moment arm
subject=["p7"];
Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];
Data.trial=[];
MCP_XYZ_Data_Combined=[];
counter=0;
load([Basepath '\MCP_data.mat']);


Model_path=append(Basepath,'\Moca\',subject,"\exp19_p7_raj.osim");
model=Model(Model_path);
for K=1:length(Knee)
    for A=1:length(Ankle)
        fcoboname=append(Knee(K),"_",Ankle(A));
        Wrapping_param=Data.(fcoboname).WrappingPar;
        wrap_r=Wrapping_param(1);
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
        Data.(fcoboname).Momentarm=Momentarm;
    end
end
