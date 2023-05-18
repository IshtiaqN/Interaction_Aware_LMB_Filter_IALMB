function glmb_update= up_date(tt_lmb_birth,tt_lmb_survive,glmb_predict,model,filter,meas,k)
%create updated tracks (single target Bayes update)
m= size(meas.Z{k},2);                                   %number of measurements
tt_update= cell((1+m)*length(glmb_predict.tt),1);       %initialize cell array
% disp(length(glmb_predict.w));
% disp(length(tt_lmb_birth));
% disp(length(tt_lmb_survive));

%missed detection tracks (legacy tracks)
for tabidx= 1:length(glmb_predict.tt)
    tt_update{tabidx}= glmb_predict.tt{tabidx};         %same track table
end

%measurement updated tracks (all pairs)
allcostm= zeros(length(glmb_predict.tt),m);                                                 %global cost matrix 
for emm= 1:m
    for tabidx= 1:length(glmb_predict.tt)
        stoidx= length(glmb_predict.tt)*emm + tabidx; %index of predicted track i updated with measurement j is (number_predicted_tracks*j + i)
        w_temp= compute_pD(model,glmb_predict.tt{tabidx}.x).*glmb_predict.tt{tabidx}.w(:).*compute_likelihood(model,meas.Z{k}(:,emm),glmb_predict.tt{tabidx}.x)'+eps(12); x_temp= glmb_predict.tt{tabidx}.x;  %weight update for this track and this measuremnent      
        tt_update{stoidx}.x= x_temp;                                                        %particles for updated track
        tt_update{stoidx}.w= w_temp/sum(w_temp);                                            %weights of partcles for updated track
        tt_update{stoidx}.l = glmb_predict.tt{tabidx}.l;                                    %track label
        allcostm(tabidx,emm)= sum(w_temp);                                                  %predictive likelihood
    end
end
glmb_update.tt= tt_update;                                                                  %copy track table back to GLMB struct

%precalculation loop for average detection/missed probabilities
avpd= zeros(length(glmb_predict.tt),1);
for tabidx=1:length(glmb_predict.tt)
    avpd(tabidx)= glmb_predict.tt{tabidx}.w(:)'*compute_pD(model,glmb_predict.tt{tabidx}.x)+eps(0);
end
avqd= 1-avpd;

%component updates
if m==0 %no measurements means all missed detections
    for pidx=1:length(glmb_predict.w)
        glmb_update.w(pidx)= -model.lambda_c+sum(log(avqd(glmb_predict.I{pidx})))+log(glmb_predict.w(pidx));            %hypothesis/component weight
    end
    glmb_update.I= glmb_predict.I;                                                                                      %hypothesis/component tracks (via indices to track table)
    glmb_update.n= glmb_predict.n;                                                                                      %hypothesis/component cardinality
else %loop over predicted components/hypotheses
    runidx= 1;
    for pidx=1:length(glmb_predict.w)
        if glmb_predict.n(pidx)==0 %no target means all clutter
            glmb_update.w(runidx)= -model.lambda_c+m*log(model.lambda_c*model.pdf_c)+log(glmb_predict.w(pidx));
            glmb_update.I{runidx}= glmb_predict.I{pidx};
            glmb_update.n(runidx)= glmb_predict.n(pidx);
            runidx= runidx+1;
        else %otherwise perform update for component
            %calculate best updated hypotheses/components
            costm= allcostm(glmb_predict.I{pidx},:)./(model.lambda_c*model.pdf_c*repmat(avqd(glmb_predict.I{pidx}),[1 m]));                     %cost matrix
            neglogcostm= -log(costm);                                                                                                           %negative log cost
%             [uasses,nlcost]= mbestwrap_updt_custom(neglogcostm,round(filter.H_upd*sqrt(glmb_predict.w(pidx))/sum(sqrt(glmb_predict.w))));       %murty's algo to calculate m-best assignment hypotheses/components
         try   
[uasses,nlcost]= mbestwrap_updt_custom(neglogcostm,ceil(filter.H_upd*sqrt(glmb_predict.w(pidx))/sum(sqrt(glmb_predict.w))));       %murty's algo to calculate m-best assignment hypotheses/components
%             if (isempty(nlcost))
%                 uasses=[];
%                 [uasses,nlcost]= mbestwrap_updt_custom(neglogcostm,ceil(filter.H_upd*sqrt(glmb_predict.w(pidx))/sum(sqrt(glmb_predict.w))));       %murty's algo to calculate m-best assignment hypotheses/components
%             end
         catch
             disp('Something wrong');
         end
            %generate corrresponding surviving hypotheses/components
            for hidx=1:length(nlcost)
                update_hypcmp_tmp= uasses(hidx,:)';
                glmb_update.w(runidx)= -model.lambda_c+m*log(model.lambda_c*model.pdf_c)+sum(log(avqd(glmb_predict.I{pidx})))+log(glmb_predict.w(pidx))-nlcost(hidx);       %hypothesis/component weight
                glmb_update.I{runidx}= length(glmb_predict.tt).*update_hypcmp_tmp+glmb_predict.I{pidx};                                                                     %hypothesis/component tracks (via indices to track table)
                glmb_update.n(runidx)= glmb_predict.n(pidx);                                                                                                                %hypothesis/component cardinality
                runidx= runidx+1;
            end
        end
    end
end
% try
    glmb_update.w= exp(glmb_update.w-logsumexp(glmb_update.w));                                                                                                                 %normalize weights
% catch
%    disp('Ooops');
% end
%extract cardinality distribution
for card=0:max(glmb_update.n)
    glmb_update.cdn(card+1)= sum(glmb_update.w(glmb_update.n==card));                                                                                                       %extract probability of n targets
end
end


