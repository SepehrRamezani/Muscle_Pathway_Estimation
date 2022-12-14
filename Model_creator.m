function Model_creator(filedata)
import org.opensim.modeling.*;
Basepath=filedata.Basepath;
whichleg=filedata.whichleg;

%% name of joints bodies and muscles

Weldjoints=["mtp","subtalar"];
Weldjoints=addingleg(Weldjoints,whichleg);
SimMusclename= ["gaslat"];
SimMusclename=addingleg(SimMusclename,whichleg);
joints=["ground_pelvis","hip","walker_knee","patellofemoral","ankle","mtp","subtalar","UltraSound_tibia","Ultrasound_Plane"];
joints(2:end-1)=addingleg(joints(2:end-1),whichleg);
Bodies=["pelvis","UltraSound","Muscle_C","femur","tibia","patella","talus","calcn","toes"];
Bodies(4:end)=addingleg(Bodies(4:end),whichleg);

%%
Subject=[];
for S=1:length(filedata.trialas) 
    trial_name=char(filedata.trialas(S));
    indxuderline=strfind(trial_name,'_');
    s=trial_name(1:indxuderline(1)-1);
    Subject=addfun(Subject,s);
end

for S=1:length(Subject)    
    Trc_path=append(Basepath,'\Moca\',Subject(S),'\');
    model=Model(append(Trc_path,Subject(S),"_raj.osim"));

% model.print(append(Trc_path,Subject(S),"_raj_act.osim"))
for Musindx = 0:model.getActuators().getSize()-1
    frcset = model.getActuators().get(Musindx);
    if ~sum(strcmp(char(frcset.getName()), SimMusclename))
        isremove=model.updForceSet().remove(frcset);
    end
end
model.initSystem();
%% Constratins 
if whichleg==["r"]
    const=model.getConstraintSet.get('patellofemoral_knee_angle_l_con');
else
    const=model.getConstraintSet.get('patellofemoral_knee_angle_r_con');
end
model.updConstraintSet.remove(const);
%% joint
jonames=ArrayStr();
model.getJointSet().getNames(jonames);
for jo = 0:1:jonames.getSize()-1 
    if ~sum(strcmp(char(jonames.get(jo)), joints))
        curjoint=model.getJointSet.get(jonames.get(jo));
        model.updJointSet().remove(curjoint);
    else
    end
end
%% Configure Bodies
bonames=ArrayStr();
model.getBodySet().getNames(bonames);
for bo = 0:1:bonames.getSize()-1   
    if ~sum(strcmp(char(bonames.get(bo)), Bodies))
        curbody=model.getBodySet.get(bonames.get(bo));
        model.updBodySet().remove(curbody);
    end
end
model.initSystem();

modeljointSet=model.getJointSet();
pelvisjoint=modeljointSet.get(0);
hipjoint=modeljointSet.get(1);
% CurrjointParent=Currjoint.get_frames(0);
CurrjointChild=hipjoint.get_frames(1);
% JointWelded=WeldJoint();
% JointWelded.setName(Currjoint.getName())
pelvisjoint.set_frames(1,CurrjointChild)
% F1=pelvisjoint.get_frames(1);
% JointWelded.connectSocket_parent_frame(F1);
% JointWelded.set_frames(1,CurrjointChild)
F2=pelvisjoint.upd_frames(1);
pelvisjoint.connectSocket_child_frame(F2)
model.updJointSet().remove(hipjoint);
curbody=model.getBodySet.get('pelvis');
model.updBodySet().remove(curbody);
% model.addJoint(JointWelded);
model.initSystem();

for m = 0:model.getCoordinateSet().getSize()-1
    Coord=model.getCoordinateSet().get(m);
    Coordname=char(Coord.getName);
    if contains(Coordname,"CLine_")&& ~(contains(Coordname,"tx")||contains(Coordname,"tz"))
        Coord.set_locked(true);
    else
        %     Coord.setDefaultValue(0);
        Coord.set_locked(false);
    end
end
model.getCoordinateSet().get("pelvis_tilt").setRange([1.5*-pi(),pi()])
model.getCoordinateSet().get("pelvis_list").setRange([-pi(),pi()])
model.getCoordinateSet().get("pelvis_rotation").setRange([1.5*-pi(),pi()/2])
model.initSystem();

for i=1:1:length(Weldjoints) 
modeljointSet=model.getJointSet();
Currjoint=modeljointSet.get(Weldjoints(i));
CurrjointParent=Currjoint.get_frames(0);
CurrjointChild=Currjoint.get_frames(1);
JointWelded=WeldJoint();
JointWelded.setName(Currjoint.getName());
JointWelded.set_frames(0,CurrjointParent);
F1=JointWelded.get_frames(0);
JointWelded.connectSocket_parent_frame(F1);
JointWelded.set_frames(1,CurrjointChild)
F2=JointWelded.get_frames(1);
JointWelded.connectSocket_child_frame(F2);
model.updJointSet().remove(Currjoint);
model.addJoint(JointWelded);
model.initSystem();
end

%% Configure actuators
% for corindx = 0:model.getCoordinateSet().getSize()-1 
%     coord=model.getCoordinateSet().get(corindx)
%     coordname=coord.getName();
%     if (~(strcmp(char(coordname), "knee_angle_l_beta")))&& ~coord.get_locked
%     coorname=char(model.getCoordinateSet().get(corindx).getName());
%     addCoordinateActuator(model, coorname, 100);
%     end
% end

model.initSystem();
model.print(append(Trc_path,Subject(S),"_raj_modified.osim"));
fprintf('Model of %s is modifed\n',Subject(S));
end

function [data]= addingleg(data,whichleg)
for y=1:length(data)
    data(y)=append(data(y),"_",whichleg);
end
end
function addCoordinateActuator(model, coordName, optimalForce)

import org.opensim.modeling.*;

coordSet = model.updCoordinateSet();

actu = CoordinateActuator();
actu.setName(append('tau_',coordName));
actu.setCoordinate(coordSet.get(coordName));
actu.setOptimalForce(optimalForce);
actu.setMinControl(-1);
actu.setMaxControl(1);
model.addComponent(actu);

end
end
