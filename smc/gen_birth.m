%generating birth particles for all Time frames and saving in a '.mat'
%file, which can be loaded for different versions of the filter.

function [tt_lmb_birth_cell] = gen_birth(init_vel,truth,model,meas,filter)
% tt_lmb_birth1=cell(size(truth.X{1},2),1);
% tt_lmb_birth=cell(model.T_birth,1);
tt_lmb_birth_cell=cell(meas.K,1);
for k = 1:meas.K
    if k==1
        %generate birth particles around all ground truth for first frame
        tt_lmb_birth=cell(size(truth.X{k},2),1);
        for tabfidx=1:size(truth.X{k},2)
            tt_lmb_birth{tabfidx}.r=0.99;
            tt_lmb_birth{tabfidx}.x=gen_gms_first(init_vel(:,tabfidx),truth.X{k}(:,tabfidx),filter.npt);
            tt_lmb_birth{tabfidx}.w= ones(filter.npt,1)/filter.npt;                                                             %weights of samples for birth track
            tt_lmb_birth{tabfidx}.l= [k;tabfidx];                                                                               %track label
        end
        tt_lmb_birth_cell{k}=tt_lmb_birth;
    else
        %generate birth as gaussian mixtures
        
        tt_lmb_birth= cell(length(model.r_birth),1);                                                                            %initialize cell array
        for tabbidx=1:length(model.r_birth)
            tt_lmb_birth{tabbidx}.r= model.r_birth(tabbidx);                                                                    %birth prob for birth track
            tt_lmb_birth{tabbidx}.x= gen_gms(model.w_birth{tabbidx},model.m_birth{tabbidx},model.P_birth{tabbidx},filter.npt);  %samples for birth track
            tt_lmb_birth{tabbidx}.w= ones(filter.npt,1)/filter.npt;                                                             %weights of samples for birth track
            tt_lmb_birth{tabbidx}.l= [k;tabbidx];                                                                               %track label
        end
        tt_lmb_birth_cell{k}=tt_lmb_birth;
    end
end


end