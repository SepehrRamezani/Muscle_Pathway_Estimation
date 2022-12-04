clc, close, clearvars
pkg load io

%ultrasound data
Pardata=importdata('C:\MyCloud\GitHub\AddresseforMusclepathwayproject.txt');
basepath=Pardata{1};
b=append(basepath,'\Experiment19(P7).xlsx');
%frame reduction key
c=append(basepath,'\key_exp19_p7.xlsx');

m = 1;
y = {'A';'C';'D';'H';'J';'K';'O';'Q';'R';'V';'X';'Y';'AC';'AE';'AF';'AJ';'AL';'AM';'AQ';'AS';'AT';'AX';'AZ';'BA';'BE';'BG';'BH'};
u = [0;30;60;90;110;];

key = zeros(45,3);
key = xlsread(c, 'Sheet1', 'A2:C46');

%---------------------------

%knee angles
ka = {'000';'030';'060';'090';'110'};
%ankle angles
aa = {'000';'D10';'P30'};
%base location of moco
q = append(basepath,'\p7_trc\');


%will increase by 1 for each iteration through inner for-loop
w = 1;

%for each knee angle
for i = 1:5
    
    %for each ankle angle
    for j = 1:3
        
        %for each trial
        for k = 1:3
            % ##i = 2;
            % ##j = 1;
            % ##k = 3;
            % ##m = 7;
            % ##w = 12;
            %moco spreadsheet location
            d = append(q,'K',ka{i},'_',aa{j},'_L_',mat2str(k),'.xlsx');
            
            %sheet name
            sn = append('K',ka{i},'_',aa{j},'_L_',mat2str(k));
            
            
            %number of ultrasound frames -- first column of each row of spreadsheet
            numberofframesUS = key(w,1);
            %make array for US data
            us = zeros(numberofframesUS,3);
            %add 4 to that -- cell number of last row of ultrasound data in spreadsheet
            numfadj = numberofframesUS + 4;
            %ultrasound frames per second -- third column of each row of spreadsheet
            fpsUS = key(w,3);
            %number of motion capture frames -- second column of each row of spreadsheet
            numberofframesMOCO = key(w,2);
            %add 12 to that -- cell number of last row of moco data in spreadsheet
            nummocoadj = numberofframesMOCO + 12;
            %motion capture frames per second
            fpsMOCO = 100;
            %number of ultrasound frames x 35 array of zeros -- for interpolated data
            gmoco = zeros(numberofframesUS,52);
            
            
            
            %cell numbers of frame numbers -- A5:A(last row of data)?
            temp = strcat(y{m},"5:",y{m}, num2str(numfadj));
            %knee angle -- sheet name
            temp2 = strcat("K",num2str(ka{i}));
            %one column of ultrasound timestamps from ultrasound spreadsheet -- frames/fps=s
            us(:,1) = (1/fpsUS)*xlsread(b,temp2,temp);
            %cell numbers of centroid data -- C5:D(last row of data)?
            temp3 = strcat(y{m+1},'5:',y{m+2}, num2str(numfadj));
            %next two columns of centroid data from ultrasound spreadsheet
            us(:,2:3) = xlsread(b,temp2,temp3);
            
            
            
            %cell numbers of motion capture timestamps and data
            temp4 = strcat('A12:AT', num2str(nummocoadj));
            %array of motion capture data from spreadsheet
            moco = zeros(nummocoadj,46);
            moco = xlsread(d,sn,temp4);
            %subtract 72.72 mm from centroid in x direction -- convert to meters -- make 34th column
            gmoco(:,50) = ((us(:,2) - 72.72)/1000); %had -156.2 before /1000
            %subtract 9.28 mm from centroid in y direction -- convert to meters -- make 36th column
            gmoco(:,52) = ((us(:,3) - 9.28)/1000); %had  -14.2 before /1000
            
            %make timestamps 1st column
            gmoco(:,1)  = us(:,1);
            %2nd column through (number of markers)th column -- uses motion capture timestamps and following data to interpolate data using ultrasound timestamps
            for z = 2:46 %#2nd number based off # of markers and results desired in final mot
                gmoco(:,z) = interp1(moco(:,1),moco(:,z),us(:,1));
            end
            
            
            
            %new file name
            F_fnames = strcat(sn,'_goodmoco.mot');
            %new file location
            Datafolder = append(basepath,'\moco_reduced\');
            %new file headers?
            Dataheadermotion = 'time\tpelvis_tilt\tpelvis_list\tpelvis_rotation\tpelvis_tx\tpelvis_ty\tpelvis_tz\thip_flexion_r\thip_adduction_r\thip_rotation_r\tknee_angle_r\tknee_angle_r_beta\tankle_angle_r\tsubtalar_angle_r\tmtp_angle_r\thip_flexion_l\thip_adduction_l\thip_rotation_l\tknee_angle_l\tknee_angle_l_beta\tankle_angle_l\tsubtalar_angle_l\tmtp_angle_l\tlumbar_extension\tlumbar_bending\tlumbar_rotation\tarm_flex_r\tarm_add_r\tarm_rot_r\telbow_flex_r\tpro_sup_r\twrist_flex_r\twrist_dev_r\tarm_flex_l\tarm_add_l\tarm_rot_l\telbow_flex_l\tpro_sup_l\twrist_flex_l\twrist_dev_l\tUS_rx\tUS_ry\tUS_rz\tUS_tx\tUS_ty\tUS_tz\tCLine_rx\tCLine_ry\tCLine_rz\tCLine_tx\tCLine_ty\tCLine_tz';
            % ?
            Title='\nversion=1\nnRows=%d\nnColumns=%d\ninDegrees=yes\nendheader\n';
            % ?
            [r,c] = size(gmoco);
            Titledata = [r,c];
            %interpolated data
            MDatadata = gmoco;
            % ?
            delimiterIn = '\t';
            %create the new file
            makefile(Datafolder,F_fnames,Title,Titledata,Dataheadermotion,MDatadata,5,delimiterIn);
            disp(F_fnames)
            
            
            w++;
            m = m + 3;
            
            
        end
        
        
        
    end
    
    m = 1;
    
end


%----------------------------





