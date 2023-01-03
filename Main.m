clear all
close all
import org.opensim.modeling.*;
% myLog = JavaLogSink();
% Logger.addSink(myLog);
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
filedata.Basepath=Pardata{1};
diarydir=append(filedata.Basepath,"\log.txt");
diary (diarydir)
filedata.Subject=["p5","p6","p7","p8","p10","p12"];
% filedata.Subject=["p6"];
filedata.whichleg="l";
filedata.Knee = ["K0","K30","K60","K90","K110"];
% filedata.Knee = ["K30"];
filedata.Ankle = ["0","D10","P30"];
% filedata.Ankle = ["0"];
filedata.Trial = ["1","2","3"];
% filedata.Trial = ["3"];

% c3dtotrc(filedata)
% US_Data_prepration(filedata);
Model_creator(filedata)
Running_IK(filedata);
CombiningData(filedata);
% MCP_Calculator(filedata);
% WrapObject_Calculator(filedata);
% FinalData=Momentarm_Calculator(filedata);
diary off