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
        curbody=model.getBodySet.get('tibia_l');
        WrapObj=curbody.getWrapObjectSet().get('GasLat_at_shank_l');
        set_radius()
        set_translation (Vec3())
        set_xyz_body_rotation (Vec3())
    end
end
