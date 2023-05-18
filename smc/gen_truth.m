%This function extracts the ground truth data from .xml file format. The
%data is originally generated using MATLAB's Ground Truth Labeler
%Application and saved in a '.mat' file. This data is later written into an
%'.xml' file, which is imported by this function and a ground truth
%variable is created from it.

function [truth , init_vel ] = gen_truth(Paths,N_Vehicles)

fprintf('Generating truth for 200 Vehicles\n');
[gt_data] = xml2struct(sprintf(Paths.Truth,N_Vehicles));
% Target state is 4* matrix
% truth.track_list is 1*N matrix containing target ids
% truth.N = truth.total_tracks is total number of tracks

truth.K= length(gt_data.dataset.Frame); %length of data/number of scans/number of frames
truth.X= cell(truth.K,1);          	%ground truth for states of targets
truth.N= zeros(truth.K,1);         	%ground truth for number of targets
truth.L= cell(truth.K,1);           %ground truth for labels of targets (k,i)
truth.track_list= cell(truth.K,1);  %absolute index target identities (plotting)
truth.total_tracks= 200;             %total number of appearing tracks
init_vel=[];

for time = 1 : length(gt_data.dataset.Frame)
    if (time == 1)
        if isfield(gt_data.dataset.Frame{time}.objectlist,'object') == 0
            truth.X{time} = [];
        elseif (length(gt_data.dataset.Frame{time}.objectlist.object)) == 1
            
            index = str2double(char(extractAfter(gt_data.dataset.Frame{time}.objectlist.object{frame}.Attributes.id,1)));
            
            X = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.x));
            Y = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.y));
            W = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.w));
            H = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.h));
            
            Vx=double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.vx));
            Vy=double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.vy));
            
            Xc=round(X+(W/2));
            Yc=round(Y+(H/2));
            
            truth.X{time}= [truth.X{time} [Xc Yc]'];
            truth.track_list{time} = [truth.track_list{time} index];
            truth.N(time) = truth.N(time) + 1;
            init_vel=[init_vel [Vx Vy]' ];
        else
            number_of_objects = length(gt_data.dataset.Frame{time}.objectlist.object);
                        
            for frame = 1 : number_of_objects
                X = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.x));
                Y = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.y));
                W = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.w));
                H = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.h));
                
                Vx=double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.vx));
                Vy=double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.vy));
                
                index = str2double(char(extractAfter(gt_data.dataset.Frame{time}.objectlist.object{frame}.Attributes.id,1)));
                
                Xc=round(X+(W/2));
                Yc=round(Y+(H/2));
                
                truth.X{time}= [truth.X{time} [Xc Yc]'];
                truth.track_list{time} = [truth.track_list{time} index];
                truth.N(time) = truth.N(time) + 1;
                
                init_vel = [init_vel [Vx Vy]' ];
            end
        end
    elseif (time > 1)
        if isfield(gt_data.dataset.Frame{time}.objectlist,'object') == 0
            truth.X{time} = [];
        elseif (length(gt_data.dataset.Frame{time}.objectlist.object)) == 1
            
            index = str2double(char(extractAfter(gt_data.dataset.Frame{time}.objectlist.object{frame}.Attributes.id,1)));
            
            X = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.x));
            Y = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.y));
            W = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.w));
            H = double(str2double(gt_data.dataset.Frame{time}.objectlist.object.box.Attributes.h));
            
            Xc=round(X+(W/2));
            Yc=round(Y+(H/2));
            
            truth.X{time}= [truth.X{time} [Xc Yc]'];
            truth.track_list{time} = [truth.track_list{time} index];
            truth.N(time) = truth.N(time) + 1;
        else
            number_of_objects = length(gt_data.dataset.Frame{time}.objectlist.object);
            
            for frame = 1 : number_of_objects
                X = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.x));
                Y = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.y));
                W = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.w));
                H = double(str2double(gt_data.dataset.Frame{time}.objectlist.object{frame}.box.Attributes.h));
                index = str2double(char(extractAfter(gt_data.dataset.Frame{time}.objectlist.object{frame}.Attributes.id,1)));
                
                Xc=round(X+(W/2));
                Yc=round(Y+(H/2));
                
                truth.X{time}= [truth.X{time} [Xc Yc]'];
                truth.track_list{time} = [truth.track_list{time} index];
                truth.N(time) = truth.N(time) + 1;
            end
        end
    end
end
end

