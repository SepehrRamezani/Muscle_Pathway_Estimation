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
Subject=["p1","p5","p6","p7","p8","p9","p10","p11","p12","p13"];
% Subject=["p9"];
filedata.whichleg="l";
Knee = ["K0","K30","K60","K90","K110"];
% Knee = ["K110"];
Ankle = ["0","D10","P30"];
% Ankle = ["0"];
% Trial = ["1","2","3"];
Trial = ["1","2","3"];
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
[filedata] = makingcombo(filedata);
% filedata=fixing_Error();
% c3dtotrc(filedata)
% US_Data_prepration(filedata);
% Model_creator(filedata)
% Running_IK(filedata);
% CombiningData(filedata);
% MCP_Calculator(filedata);
% WrapObject_Calculator(filedata);
FinalData=Momentarm_Calculator(filedata);
GFinalData=GenModel_Momentarm_Calculator_extraxction(filedata);
diary off
function [filedata] = makingcombo(filedata)
fcoboname=[];
for S=1:length(filedata.trialas)
    trial_name=char(filedata.trialas(S));
    indxuderline=strfind(trial_name,'_');
    NSubject=trial_name(1:indxuderline(1)-1);
    trial=trial_name(indxuderline(4)+1:end);
    newfcoboname=erase(trial_name,append("_L_",trial));
    fcoboname=addfun(fcoboname,newfcoboname);
end
filedata.fcoboname=fcoboname;
end