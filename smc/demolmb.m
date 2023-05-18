%This is the demo script for the Interaction-aware LMB Filter proposed in
%IEEE Trans. Intelligent Transportation systems paper which can be found at: https://arxiv.org/pdf/2204.08655.pdf
%
% @article{ishtiaq2022interaction,
%   title={Interaction-aware labeled multi-bernoulli filter},
%   author={Ishtiaq, Nida and Gostar, Amirali Khodadadian and Bab-Hadiashar, Alireza and Hoseinnezhad, Reza},
%   journal={arXiv preprint arXiv:2204.08655},
%   year={2022}}
% 
% This is the demo script which is a modification of the Labeled Multi-Bernoulli filter proposed in
% S. Reuter, B.-T. Vo, B.-N. Vo, and K. Dietmayer, "The labelled multi-Bernoulli filter," IEEE Trans. Signal Processing, Vol. 62, No. 12, pp. 3246-3260, 2014
% http://ba-ngu.vo-au.com/vo/RVVD_LMB_TSP14.pdf
% which propagates an LMB approximation of the GLMB update proposed in
% B.-N. Vo, B.-T. Vo, and D. Phung, "Labeled Random Finite Sets and the Bayes Multi-Target Tracking Filter," IEEE Trans. Signal Processing, Vol. 62, No. 24, pp. 6554-6567, 2014
% http://ba-ngu.vo-au.com/vo/VVP_GLMB_TSP14.pdf
%
% Note 1: no dynamic grouping or adaptive birth is implemented in this code, only the standard filter with static birth is given
% Note 2: the simple example used here is the same as in the CB-MeMBer filter code for a quick demonstration and comparison purposes
% Note 3: more difficult scenarios require a better lookahead and more components/hypotheses (and exec time)
% ---BibTeX entry
% @ARTICLE{LMB,
% author={S. Reuter and B.-T. Vo and B.-N. Vo and K. Dietmayer},
% journal={IEEE Transactions on Signal Processing},
% title={The Labeled Multi-Bernoulli Filter},
% year={2014},
% month={Jun}
% volume={62},
% number={12},
% pages={3246-3260}}
%
% @ARTICLE{GLMB2,
% author={B.-T. Vo and B.-N. Vo and D. Phung},
% journal={IEEE Transactions on Signal Processing},
% title={Labeled Random Finite Sets and the Bayes Multi-Target Tracking Filter},
% year={2014},
% month={Dec}
% volume={62},
% number={24},
% pages={6554-6567}}
%
%
%-------------------------------------------------------------------------------------------
% In order to run the filter, run this demo file, change any paths and/or
% dataset as required, along witht he filter parameters. If the dataset is
% changed, a new set of birth and model parameters may need to be defined
% and birth parameters generated using the 'gen_birth.m' function from the
% directory. New measurements need to be generated using the 'gen_meas.m'
% function and the path for new file updated in the Paths structure
% accordingly.

clear all; close all; clc;
Current_Path = cd;
cd ../..
old_Path = pwd;
old_Path= strrep(old_Path,'\','/');
N_Vehicles=200;     %Number of vehicles

Paths.Common_Functions = [old_Path , '/Code/smc/_common'];
%this part is specific to 200 labeled vehicles in the dataset 

Paths.Measurements_200 = [old_Path , '/Data/Detections/meas_pd98_noise_small.mat'];
Paths.Truth_200 = [old_Path , '/Data/GroundTruth/gt_data_%d_vehicles_corrected_final2.xml'];
Paths.Images_200 = [old_Path , '/Data/Images'];
Paths.XML_Results = [old_Path , '/Results/For_VT_Example_%d_Vehicles_2020_13_08.xml'];
Paths.Video_Path = [old_Path , '/Results/For_VT_Example_%d_Vehicles_2020_13_08.avi'];
Paths.Result_Images = [old_Path , '/Results/Images/result_%03d.png'];
Paths.Pairs_Int = [old_Path , '/Results/Pairs_Interaction_%d_Vehicles_2020_13_08.txt'];
Paths.Birth = [old_Path , '/Code/birth_particles.mat'];


addpath(Paths.Common_Functions);

%Image specifications
Sequence_Length = 245;  %number of images used from video
Image_Height = 1080;    %Image height in pixels (y)
Image_Width = 1920;     %Image width in pixels (x)

%generalization of paths for specific dataset (200 vehicles in this case)
Paths.Images = Paths.Images_200;
Paths.Truth = Paths.Truth_200;
Paths.Measurements = Paths.Measurements_200;
Paths.Measurements= strrep(Paths.Measurements,'/','\');
cd(Paths.Images);
Image_List = [dir('*.jpg'); dir('*.png')];
cd(Current_Path);

Writer_Object = VideoWriter(sprintf(Paths.Video_New_Meas,N_Vehicles));
Writer_Object.FrameRate=2;
Results_File = fopen(sprintf(Paths.XML_Results,N_Vehicles),'w+');
fprintf(Results_File,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(Results_File, sprintf('<Results name="Vehicles_%d">\n',N_Vehicles));

%open the file to write label pairs for each frame
Pairs_File = fopen (sprintf(Paths.Pairs_Int,N_Vehicles),'wt+');
fprintf(Pairs_File,'Label pairs for each frame \n');

hh=figure(1);
open(Writer_Object);

%generate model parameters (constant velocity model)
model=gen_model;

%generate ground truth from the xml file
[truth , init_vel ] = gen_truth(Paths,N_Vehicles);

load(Paths.Measurements);
load(Paths.Birth);


%output variables
est.X= cell(meas.K,1);
est.N= zeros(meas.K,1);
est.L= cell(meas.K,1);

%filter parameters
filter.T_max= 300;                  %maximum number of tracks
filter.track_threshold= 1e-4;
filter.H_bth= 64;                    %requested number of birth components/hypotheses (for LMB to GLMB casting before update)
filter.H_sur= 300;                  %requested number of surviving components/hypotheses (for LMB to GLMB casting before update)
filter.H_upd= 300;                  %requested number of updated components/hypotheses (for GLMB update)
filter.H_max= 300;                  %cap on number of posterior components/hypotheses (not used yet)
filter.hyp_threshold= 1e-7;         %pruning threshold for components/hypotheses (not used yet) 1e-7

filter.npt= 200;                   %number of particles per track
filter.nth= 200;                    %threshold on effective number of particles before resampling (not used here, resampling is forced at every step, otherwise number of particles per track grows)

filter.run_flag= 'disp';            %'disp' or 'silence' for on the fly output

est.filter= filter;

%=== Filtering

%initial prior
tt_lmb_update= cell(0,1);      %track table for LMB (cell array of structs for individual tracks)
pairs=cell(meas.K,1);
%recursive filtering
for Time=1:meas.K
    %include below 2 lines for video with scene
    Image = imread(strcat(Paths.Images,'\',Image_List(Time).name));
    imshow(Image);hold on;
    
    if Time == 1
        
        [tt_lmb_survive]= lmbpredict(init_vel,truth,tt_lmb_update,est.X{Time},est.L{Time},model,filter,Time,pairs{Time});
    else
         
        [tt_lmb_survive]= lmbpredict(init_vel,truth,tt_lmb_update,est.X{Time-1},est.L{Time-1},model,filter,Time,pairs{Time-1});
    end
    
    
    %update
        glmb_predict= castlmbpred(tt_lmb_birth_cell{Time},tt_lmb_survive,filter);
    glmb_update= up_date(tt_lmb_birth_cell{Time},tt_lmb_survive,glmb_predict,model,filter,meas,Time);
    tt_lmb_update= glmb2lmb(glmb_update);
    
    %pruning, truncation and track cleanup
    tt_lmb_update= clean_lmb(tt_lmb_update,filter,Image_Width,Image_Height);
    
    %state estimation
    [est.X{Time},est.N(Time),est.L{Time}]= extract_estimates(tt_lmb_update,model,Image_Width,Image_Height);
    
    L_prune=[]; %labels to be pruned in current iteration
    
    %If a track exits the scene, we can prune its track to rule out
    %misdetections, this is just a safety step.
    idx_remove=find(est.X{Time}(1,:)>Image_Width);
    L_prune=[L_prune , est.L{Time}(:,idx_remove)];
    est.X{Time}(:,idx_remove)=[];
    est.L{Time}(:,idx_remove)=[];
    est.N(Time)=est.N(Time)-(length(idx_remove));
    
    idx_remove2=find(est.X{Time}(1,:)<0);
    L_prune=[L_prune , est.L{Time}(:,idx_remove2)];
    est.X{Time}(:,idx_remove2)=[];
    est.L{Time}(:,idx_remove2)=[];
    est.N(Time)=est.N(Time)-(length(idx_remove2));
    
    idx_remove3=find(est.X{Time}(3,:)>Image_Height);
    L_prune=[L_prune , est.L{Time}(:,idx_remove3)];
    est.X{Time}(:,idx_remove3)=[];
    est.L{Time}(:,idx_remove3)=[];
    est.N(Time)=est.N(Time)-(length(idx_remove3));
    
    idx_remove4=find(est.X{Time}(3,:)<0);
    L_prune=[L_prune , est.L{Time}(:,idx_remove4)];
    est.X{Time}(:,idx_remove4)=[];
    est.L{Time}(:,idx_remove4)=[];
    est.N(Time)=est.N(Time)-(length(idx_remove4));
    
    track_rem=[];
    for p=1:size(L_prune,2)
        for i=1:length(tt_lmb_update)
            if (tt_lmb_update{i}.l==L_prune(:,p))
                track_rem=[track_rem i];
            end
        end
    end
    
    tt_lmb_update(track_rem,:)=[];
    
    %write the extracted tracks results into an XML file
    Write_XML(est.X{Time},est.N(Time),est.L{Time},Time,Results_File);
    
    
    
    %display current frame information
    fprintf('Frame = %f \n', Time);
    fprintf('Birth Tracks = %f \n',length(tt_lmb_birth_cell{Time}));
    fprintf('Surviving Tracks = %f \n',length(tt_lmb_survive));
    fprintf('Updated Tracks = %f \n',length(tt_lmb_update));
    fprintf('Truth tracks = %f \n',truth.N(Time));
    fprintf('Estimated tracks = %f \n',est.N(Time));
    
   
    hold on;
   
    %Plot measurements (centre point)
    parfor n=1:size(meas.Z{Time},2)
        plot(meas.Z{Time}(1,n),meas.Z{Time}(2,n),'Marker','s','MarkerSize',2,'MarkerEdgeColor','g');
        pause(0.05)
    end
    
    %     plot estimates
    parfor n=1:est.N(Time)
        plot(est.X{Time}(1,n),est.X{Time}(3,n),'Marker','s','MarkerSize',10,'MarkerEdgeColor','r');
        text(round(est.X{Time}(1,n)),round(est.X{Time}(3,n)),strcat(int2str(est.L{Time}(1,n)),',',int2str(est.L{Time}(2,n))),'Color','r','FontSize',10);
        pause(0.1)
    end
    
    %plot the estimated velocity vector on the vehicles
    quiver (est.X{Time}(1,:),est.X{Time}(3,:),est.X{Time}(2,:),est.X{Time}(4,:),'Color','y','LineWidth',1);
    
    %Capture the current frame, write video and save image for results
    Frame = getframe(gcf);
    writeVideo(Writer_Object,Frame);
    
    filename = sprintf(Paths.Result_Images,Time);
    imwrite(Frame.cdata,filename);
    hold off;

    %Now generate label pairs for the current frame if the frame number is
    %equal to 5 or more
    
    if (Time >=5)
        pairs{Time} = get_label_pairs(pairs{Time-1},est.X{Time},est.N(Time),est.L{Time},est.X{Time-1},est.N(Time-1),est.L{Time-1},est.X{Time-2},est.N(Time-2),est.L{Time-2});
        write_pairs_file(pairs{Time},Time,Pairs_File);
    end
%         
%         
    
end
close(Writer_Object);
fprintf(Results_File,'</Results>');
