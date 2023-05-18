function [tt_lmb_survive]= lmbpredict(init_vel,truth,tt_lmb_update,est_X,est_L,model,filter,k,pairs)
if k==1
    %birth particles have already been generated separately and loaded into
    %memory

    %---generate surviving tracks
    tt_lmb_survive= cell(length(tt_lmb_update),1);
    
elseif k<=5
    %birth particles have already been generated separately and loaded into
    %memory
    
    %---generate surviving tracks according to interaction and NCV model
    tt_lmb_survive= cell(length(tt_lmb_update),1);                                                                              %initialize cell array
    for tabsidx=1:length(tt_lmb_update)    
        %first we propagate particles according to NCV model
        wtemp_predict= compute_pS(model,tt_lmb_update{tabsidx}.x).*tt_lmb_update{tabsidx}.w(:); xtemp_predict= gen_newstate_fn(model,tt_lmb_update{tabsidx}.x,'noise');      %particle prediction
        tt_lmb_survive{tabsidx}.r= sum(wtemp_predict)*tt_lmb_update{tabsidx}.r;                                                 %predicted existence probability for surviving track
        tt_lmb_survive{tabsidx}.x= xtemp_predict;                                                                               %samples for surviving track
        tt_lmb_survive{tabsidx}.w= wtemp_predict/sum(wtemp_predict);                                                            %weights of samples for predicted track
        tt_lmb_survive{tabsidx}.l= tt_lmb_update{tabsidx}.l;                                                                    %track label
    end
        
else
    %birth particles have already been generated separately and loaded into
    %memory
    
    %---generate surviving tracks according to interaction and NCV model
    tt_lmb_survive= cell(length(tt_lmb_update),1);                                                                              %initialize cell array
    tt_lmb_survive_prop= cell(length(tt_lmb_update),1); 
    for tabsidx=1:length(tt_lmb_update)    
        %first we propagate particles according to NCV model
        wtemp_predict= compute_pS(model,tt_lmb_update{tabsidx}.x).*tt_lmb_update{tabsidx}.w(:); xtemp_predict= gen_newstate_fn(model,tt_lmb_update{tabsidx}.x,'noise');      %particle prediction
        tt_lmb_survive_prop{tabsidx}.r= sum(wtemp_predict)*tt_lmb_update{tabsidx}.r;                                                 %predicted existence probability for surviving track
        tt_lmb_survive_prop{tabsidx}.x= xtemp_predict;                                                                               %samples for surviving track
        tt_lmb_survive_prop{tabsidx}.w= wtemp_predict/sum(wtemp_predict);                                                            %weights of samples for predicted track
        tt_lmb_survive_prop{tabsidx}.l= tt_lmb_update{tabsidx}.l;                                                                    %track label
        
        %after propagating particles, we use the interaction model to
        %adjust the particles according to the required interaction
        [tt_lmb_survive{tabsidx}]=lmb_interaction(tt_lmb_survive_prop{tabsidx},est_X,est_L,pairs);      
    end

end
end