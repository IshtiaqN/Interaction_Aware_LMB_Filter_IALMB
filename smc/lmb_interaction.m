function [tt_lmb_survive]=lmb_interaction(tt_lmb_prop,est_X,est_L,pairs)

sigma_int = 2;      %sigma for interaction modeldist_thresh=45;         %threshold of 40 pixels means min 40 pixel distance should be maintained
l_curr=tt_lmb_prop.l;

est_exist=0;
pair_exist=0;
for s=1:size(est_L,2)
    if (est_L(2,s) == l_curr(2))
        if (est_L(1,s) == l_curr(1))
            est_exist=s;
        end
    end
end

if (est_exist==0)
    tt_lmb_survive=tt_lmb_prop;%if the label does not exist in previous time estimates then go to next surviving track
    return;
else
    estx_curr=est_X(:,est_exist);   %if label exists, save its state as current estimate state
end

%check if the current vehicle has a close front vehicle in pairs, if not then return
%the propagated particles as they are
 for s1=1:size(pairs,2)
     if (pairs(2,s1) == l_curr(2))
         if (pairs(1,s1) == l_curr(1))
             pair_exist=s1;             %save the column where this pair exists
         end
     end
 end

 if (pair_exist == 0)
     tt_lmb_survive=tt_lmb_prop;    %if the label does not have a pair it means no vehicle is very close to it, so go to next surviving track
     return;
 end

 l_front=pairs([3:4],pair_exist);       %if the current label has a pair, then save the label for that pair
 id_est=[];
 for s=1:size(est_L,2)
     if (est_L(2,s) == l_front(2))
        if (est_L(1,s) == l_front(1))
            id_est=s;
        end
    end
 end
 estx_front=est_X(:,id_est);        %the state vector for the vehicle in front
 
 estx_front_prop=[estx_front(1)+estx_front(2); estx_front(3)+estx_front(4)];    %predicted next location of the front vehicle
 
 %now calculate the distance between the previous states of the label pair
 dist_xk_prev=sqrt((estx_curr(1)-estx_front(1)).^2+(estx_curr(3)-estx_front(3)).^2);
 
 %now calculate distance between the propagated particles and the estimated
 %next location of the front vehicle
 dist_xk=sqrt((tt_lmb_prop.x(1,:)-estx_front_prop(1)).^2+(tt_lmb_prop.x(3,:)-estx_front_prop(2)).^2);
 
%  [~,idp]=find(dist_xk<=dist_thresh);        %find all particles for which this distance (for posterior) is less than threshold, then we will change weights for only these particles
 
 %for the particles having lesser distance with the front vehicle,
 %calculate the normpdf, according to which we will update the weights
%  int_upd=normpdf(dist_xk(idp),dist_xk_prev,sigma_int);
 int_upd=normpdf(abs(dist_xk'-dist_xk_prev),5,sigma_int);
  
 wtemp=ones(length(tt_lmb_prop.w),1);        %initialize wtemp
%  wtemp (idp) = int_upd*tt_lmb_prop.w(idp);
  wtemp = int_upd.*tt_lmb_prop.w;
%  wtemp(setdiff(1:end,idp))=tt_lmb_prop.w(setdiff(1:end,idp));
 tt_lmb_survive.w=wtemp/sum(wtemp);
 tt_lmb_survive.r=tt_lmb_prop.r;
 tt_lmb_survive.x=tt_lmb_prop.x;
 tt_lmb_survive.l=tt_lmb_prop.l;
 
end

