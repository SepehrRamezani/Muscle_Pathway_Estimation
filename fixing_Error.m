function [filedata]=fixing_Error()
clear all
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
filedata.Basepath=Pardata{1};
Basepath=filedata.Basepath;
errdir=fullfile(Basepath,'Error_Texts','Errors.csv');
Erfile=importdata(errdir);
% Erfile=readcell(errdir,'Sheet1');
[r,c]=size(Erfile);
trialset=[];
filedata.Subject=[];
filedata.Knee=[];
filedata.Ankle=[];
filedata.Trail=[];

for i=2:r
    trialname=Erfile{i,1};
    indxs=strfind(trialname,'p');
    indxe=strfind(trialname,'L_');
    indxs=indxs(indxs<indxe);
    trialname_t=trialname([indxs:indxe+2]);
    indxuderline=strfind(trialname_t,'_');
%     sub=trialname_t(1:indxuderline(1)-1);
%     filedata.Subject=addfun(filedata.Subject,sub);
%     knee=trialname_t(indxuderline(1)+1:indxuderline(2)-1);
%     filedata.Knee=addfun(filedata.Knee,knee);
%     ankle=trialname_t(indxuderline(2)+1:indxuderline(3)-1);
%     filedata.Ankle=addfun(filedata.Ankle,ankle);
%     trial=trialname_t(indxuderline(4)+1:end);
%     filedata.Trail=addfun(filedata.Trail,trial);
    trialset=addfun(trialset,trialname_t);
end
filedata.trialas=trialset;
end

function [filedata] = addfun(filedata,info)
info=string(info);
if ~isempty(filedata)
    if ~sum(contains(filedata,info))
        
        filedata=[filedata,info];
    end
else
    filedata=info;
end
end