% clc, close, clearvars
% pkg load io
clear all;
%ultrasound data
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
Basepath=Pardata{1};
load([Basepath '\US_raw.mat']);
b=append(Basepath,'\Experiment19(P7).xlsx');
%frame reduction key
c=append(Basepath,'\key_exp19_p7.xlsx');
q = append(Basepath,'\Moca\p7\');
w = 1;
DsTime=0.1;

Knee = ["K0","K30","K60","K90","K110"];
Ankle = ["0","D10","P30"];
Trial = ["1","2","3"];

for K=1:length(Knee)
    for A=1:length(Ankle)
        for T=1:length(Trial)
      
            fname=append(Knee(K),"_",Ankle(A),"_L_",Trial(T));  
            
            us=Data.(fname).data;
            Moca_data=importdata(append(q,fname,"_IK.mot"));
            [r_us_coordinate,c_Moca_data]=find(strncmp(Moca_data.colheaders,'CLine_t',7));
%           Moca_data_trimed=Moca_data.data(:,c_Moca_data);
            Moca_data_interpolated = interp1(Moca_data.data(:,1),Moca_data.data,us(:,1));
            us_x = 1* ((us(:,2) - 72.72)/1000); %had -156.2 before /1000
            us_y = 1*((us(:,3) - 9.28)/1000); %had  -14.2 before /1000
            Moca_data_interpolated(:,c_Moca_data([1,3]))=[us_x,us_y];
            combined_Data=Moca_data_interpolated;
            %new file name
            F_fnames = append(fname,'_Combined.mot');
            %new file location
            Datafolder = append(q);
            %new file headers?
            Dataheadermotion = 'time\tpelvis_tilt\tpelvis_list\tpelvis_rotation\tpelvis_tx\tpelvis_ty\tpelvis_tz\thip_flexion_r\thip_adduction_r\thip_rotation_r\tknee_angle_r\tknee_angle_r_beta\tankle_angle_r\tsubtalar_angle_r\tmtp_angle_r\thip_flexion_l\thip_adduction_l\thip_rotation_l\tknee_angle_l\tknee_angle_l_beta\tankle_angle_l\tsubtalar_angle_l\tmtp_angle_l\tlumbar_extension\tlumbar_bending\tlumbar_rotation\tarm_flex_r\tarm_add_r\tarm_rot_r\telbow_flex_r\tpro_sup_r\twrist_flex_r\twrist_dev_r\tarm_flex_l\tarm_add_l\tarm_rot_l\telbow_flex_l\tpro_sup_l\twrist_flex_l\twrist_dev_l\tUS_rx\tUS_ry\tUS_rz\tUS_tx\tUS_ty\tUS_tz\tCLine_rx\tCLine_ry\tCLine_rz\tCLine_tx\tCLine_ty\tCLine_tz';
            % ?
            Title='\nversion=1\nnRows=%d\nnColumns=%d\ninDegrees=yes\nendheader\n';
            % ?
            [r,c] = size(combined_Data);
            Titledata = [r,c];
            %interpolated data
            MDatadata = combined_Data;
            % ?
            delimiterIn = '\t';
            %create the new file
            makefile(Datafolder,F_fnames,Title,Titledata,Dataheadermotion,MDatadata,5,delimiterIn);
            disp(F_fnames)
            
            
            
        end
    end
end


%----------------------------





