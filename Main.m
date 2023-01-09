clear all
close all
import org.opensim.modeling.*;
% myLog = JavaLogSink();
% Logger.addSink(myLog);
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
filedata.Basepath=Pardata{1};
diarydir=append(filedata.Basepath,"\log.txt");
% diary (diarydir)
% filedata.Subject=["p5","p6","p7","p8","p10","p12"];
% filedata.Subject=["p1","p9","p7","p11","p13"];
% Subject=["p1","p5","p6","p7","p8","p9","p10","p11","p12","p13"];
Subject=["p1"];
filedata.whichleg="l";
Knee = ["K0","K30","K60","K90","K110"];
% Knee = ["K30"];
Ankle = ["0","D10","P30"];
% Ankle = ["0"];
Trial = ["1","2","3"];
% Trial = ["3"];
trials=[];
for S=1:length(Subject)
    for K=1:length(Knee)
        for A=1:length(Ankle)
            for T=1:length(Trial)
                fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));
                fullname=append(Subject(S),"_",fname);
                trials=[trials;fullname];
            end
        end
    end
end
filedata.trialas=trials;
% filedata=fixing_Error();
% c3dtotrc(filedata)
US_Data_prepration(filedata);
% Model_creator(filedata)
% Running_IK(filedata);
% CombiningData(filedata);
% MCP_Calculator(filedata);
% WrapObject_Calculator(filedata);
% FinalData=Momentarm_Calculator(filedata);
diary off