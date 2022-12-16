clear all
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
import org.opensim.modeling.*;
 myLog = JavaLogSink();
Logger.addSink(myLog);
SimMusclename= ["gaslat_l","gasmed_l"];
Knee = ["K0"];
Ankle = ["0"];
Trial = ["1"];
Subject=["p7"];
Trc_path=append(Basepath,'\Moca\',Subject,'\');
model=Model(append(Trc_path,Subject,"_raj_act1.osim"));
load([Basepath '\US_raw.mat']);

study = MocoStudy();
study.setName('marker_tracking_US');
problem = study.updProblem();
problem.setModel(model);

markerTrackingCost = MocoMarkerTrackingGoal();
markerTrackingCost.setName('marker_tracking');

markerWeights = SetMarkerWeights();

% setup the marker weight 
for mar = 0:1:model.getMarkerSet.getSize()-1
    markername=model.getMarkerSet().get(mar).getName;
    markerWeights.cloneAndAppend(MarkerWeight(char(markername), 1));
end


% problem.setStateInfo('joint/coord/value', [-10, 10]);


for S=1:length(Subject)
    Trc_path=append(Basepath,'\Moca\',Subject,'\');
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)

              fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));  
              us=Data.(fname).data;
              problem.setTimeBounds(2, 5);
markersRef = MarkersReference(append(Trc_path,fname,"_Marker.trc"), markerWeights);
markerTrackingCost.setMarkersReference(markersRef);


            end
        end
    end
end
markerTrackingCost.setAllowUnusedReferences(true);
problem.addGoal(markerTrackingCost);
controlCost = MocoControlGoal();
controlCost.setWeight(0.001);
problem.addGoal(controlCost);


solver = study.initCasADiSolver();
solver.set_num_mesh_intervals(20);
solver.set_optim_constraint_tolerance(1e-1);
solver.set_optim_convergence_tolerance(1e-3);
solver.setGuess('bounds');
solver.set_optim_max_iterations(4000);
solver.set_implicit_auxiliary_derivatives_weight(0.00001)
solver.set_parameters_require_initsystem(false);
solver.resetProblem(problem);
solver.set_verbosity(2);
solver.set_optim_solver('ipopt');
study.print(append(Trc_path,'marker_tracking_10dof.omoco'));
solution = study.solve();
solution.write('marker_tracking_10dof_solution.sto');
if ~strcmp(getenv('OPENSIM_USE_VISUALIZER'), '0')
    study.visualize(solution);
end
Logger.removeSink(myLog);
