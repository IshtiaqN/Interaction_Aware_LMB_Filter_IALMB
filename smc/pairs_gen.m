%This function can be used to extract label pair information from a
%previous/existing set of estimates, without having to run the filter
%again.
clear all;
Nframes=245;
pairs=cell(Nframes,1);
load('C:/PHD/vehicle_LMB_interaction_new2/vehicle_new/Code/est_for_pairs.mat');



for Time=5:Nframes
    pairs{Time}=get_label_pairs(pairs{Time-1},est.X{Time},est.N(Time),est.L{Time},est.X{Time-1},est.N(Time-1),est.L{Time-1},est.X{Time-3},est.N(Time-3),est.L{Time-3});
end