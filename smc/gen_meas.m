Current_Path = cd;
cd ../..
old_Path = pwd;%convertCharsToStrings(pwd);
old_Path= strrep(old_Path,'\','/');
N_Vehicles=200;     %Number of vehicles
Paths.Truth = [old_Path , '/Data/GroundTruth/gt_data_%d_vehicles_corrected_final2.xml'];

cd(Current_Path);
model=gen_model;

truth = gen_truth(Paths,N_Vehicles);

meas =  create_meas(model,truth,N_Vehicles);

filename=[ old_Path , '/Data/Detections/meas_pd98_noise_small.mat'];
save(filename, 'meas');

function meas=create_meas(model,truth,N_Vehicles)

fprintf('Generating Measurements for %f Vehicles\n',N_Vehicles);
%Variables
meas.K= truth.K;
meas.Z= cell(truth.K,1);

%generate measurements
for k=1:truth.K
    
    if truth.N(k) > 0
        idx= find( rand(truth.N(k),1) <= model.P_D );                                            %detected target indices
        meas.Z{k}= gen_observation_fn(model,truth.X{k}(:,idx),'noise');                          %single target observations if detected
    end
    
%     %clutter generation
%     N_c= poissrnd(model.lambda_c);                                                           %number of clutter points
%     C= repmat(model.range_c(:,1),[1 N_c])+ diag(model.range_c*[ -1; 1 ])*rand(model.z_dim,N_c);  %clutter generation
%     meas.Z{k}= [ meas.Z{k} C ];                                                                  %measurement is union of detections and clutter

end


end

