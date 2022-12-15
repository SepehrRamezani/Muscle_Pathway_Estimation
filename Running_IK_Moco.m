Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Data.Basepath=Pardata{1};
import org.opensim.modeling.*;
Knee = ["K0"];
Ankle = ["0"];
Trial = ["1"];
Subject=["p7"];
study = MocoStudy();
study.setName('marker_tracking_10dof');
problem = study.updProblem();
problem.setModel(model);
problem.setTimeBounds(0, 1.25);
markerTrackingCost = MocoMarkerTrackingGoal();
markerTrackingCost.setName('marker_tracking');
model=Model(append(Trc_path,Subject,"_raj.osim"));


for S=1:length(Subject)
    Trc_path=append(Data.Basepath,'\Moca\',Subject,'\');
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
              fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));  
markersRef = MarkersReference(append(Trc_path,fname,"_Marker.trc"), ...
    markerWeights);
markerTrackingCost.setMarkersReference(markersRef);

problem.addGoal(markerTrackingCost);
controlCost = MocoControlGoal();
controlCost.setWeight(0.001);
problem.addGoal(controlCost);
            end
        end
    end
end
markerTrackingCost.setAllowUnusedReferences(true);
solver = study.initCasADiSolver();
solver.set_num_mesh_intervals(20);
solver.set_optim_constraint_tolerance(1e-3);
solver.set_optim_convergence_tolerance(1e-3);
solver.setGuess('bounds');
study.print('marker_tracking_10dof.omoco');
solution = study.solve();
solution.write('marker_tracking_10dof_solution.sto');
if ~strcmp(getenv('OPENSIM_USE_VISUALIZER'), '0')
    study.visualize(solution);
end
function addCoordinateActuator(model, coordName, optimalForce)

import org.opensim.modeling.*;

coordSet = model.updCoordinateSet();

actu = CoordinateActuator();
actu.setName(['tau_' coordName]);
actu.setCoordinate(coordSet.get(coordName));
actu.setOptimalForce(optimalForce);
% Set the min and max control defaults to automatically generate bounds for
% each actuator in the problem.
actu.setMinControl(-1);
actu.setMaxControl(1);
model.addComponent(actu);

end

