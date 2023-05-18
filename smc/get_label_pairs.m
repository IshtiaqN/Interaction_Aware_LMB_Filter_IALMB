% This function identifies interacting targets and saves their labels in
% the form of pairs in a PAIRS variable. This version of the function uses
% distance-based method to identify and implement interactions.

function [pairs] = get_label_pairs(pairs_prev,estX,estN,estL,estXprev,estNprev,estLprev,estXprev2,estNprev2,estLprev2)

dist_thresh=50; %prev 45
betav_thresh=pi/6;   % now trying for larger threshold 30 degress and removing betad_threshold.5th again 12 degrees 4th 10 deg 3rd 12 degrees , 2nd 15 deg, 1st 10 deg
betad_thresh=2*pi/45; %5th again 8 degrees (same as 3rd time) 4th 5 deg 3rd 8 degrees , 2nd 10 deg, 1st 5 deg
pairs=[];

dist_all=zeros(estN-1,estN); %create a variable for distances from time T-1
for p=1:estN
    est_temp=estX;
    est_temp(:,p)=[];
    dist_all(:,p)=sqrt((estX(1,p)-est_temp(1,:)).^2+(estX(3,p)-est_temp(3,:)).^2);
    % dist_curr=sqrt((estX_curr(1,:)-estX_curr(1,1)).^2+(estX_curr(2,:)-estX_curr(2,1)).^2);
    
end

%sort distances in ascending order
[~,idx]=sort(dist_all,'ascend');
% dist_xk=zeros(1,estN);
% dist_near=zeros(6,estN);
for p=1:estN
    %first we check if the label for p has a pair from previous time. If a
    %pair exists already, we check if distance is still within
    %threshold, then we keep the pair and move to next p
    label_curr=estL(:,p);
    pair_idx=[];
    dist_near=[];
    est_near=[];
    labels_near=[];
    n_near=[];
    
    %if no pair was found for previous time then we go on to finding
    %near vehicles from prev estimates and ignore the label pairs from
    %previous time henceforth
    t=1;
    for t=1:size(dist_all,1)
        if (dist_all(idx(t,p),p) < dist_thresh)
            dist_near=[dist_near; dist_all(idx(t,p),p)];
        else
            break;
        end
    end
    
    %     dist_near(:,p)=dist_all(idx(1:6,p),p);
    if (~isempty(dist_near))
        %         if (dist_near(1,p)<=dist_thresh)     %this seems to be close enough, e.g. for est 4 and 5 it is 34.55
        vel_est=sqrt(estX(2,p).^2+estX(4,p).^2);
        
        if (vel_est >1)     %this is usually true for non-stationary vehicles
            n_near=length(dist_near);   %number of vehicles within threshold
            if p==1
                est_near=estX(:,idx(1:n_near,p)+1);
                labels_near=estL(:,idx(1:n_near,p)+1);
            else
                for i=1:n_near
                    if idx(i,p)<p
                        est_near(:,i)=estX(:,idx(i,p));
                        labels_near(:,i)=estL(:,idx(i,p));
                    else
                        est_near(:,i)=estX(:,idx(i,p)+1);
                        labels_near(:,i)=estL(:,idx(i,p)+1);
                    end
                end
            end
            
%             %Calculate angle between velocity of current vehicle and line
%             %joining the current and nearby vehicle, we call this beta_d
%             dist_line=[est_near(1,:)-estX(1,p);est_near(3,:)-estX(3,p)];
%             
            
%             %rather than using the estimate velocity which has noise,
%             %we calculate noiseless velocity components from the
%             %previous 2 estimates
%             prev_idx=[];
%             estp_prev=[];
%             vel_curr=[];
%             vel_near=zeros(2,n_near);
%             for pr=1:estNprev       %first we find the current label in previous time
%                 %                     for l_pr=1:estNprev
%                 if ( estLprev(1,pr) == label_curr(1)) && (estLprev(2,pr) == label_curr(2))
%                     
%                     vel_curr(1)=estX(1,p)-estXprev(1,pr);
%                     vel_curr(2)=estX(3,p)-estXprev(3,pr);
%                     %                                 prev_idx = l_pr;
%                     
%                 end
%                 for l_near = 1:n_near
%                     if (estLprev(1,pr) == labels_near(1,l_near) ) && (estLprev(2,pr) == labels_near(2,l_near) )
%                         
%                         vel_near(1,l_near) = est_near(1,l_near)-estXprev(1,pr);
%                         vel_near(2,l_near) = est_near(3,l_near)-estXprev(3,pr);
%                         
%                     end
%                 end
%                 
%                 
%                 %                     end
%             end
%             for n=1:n_near
%                 if (vel_near(1,n) == 0) && (vel_near(2,n) == 0)
%                     vel_near(1,n)=est_near(2,n);
%                     vel_near(2,n)=est_near(4,n);
%                 end
%             end
            

            
            
            %                 Calculate angle between velocity of current vehicle and the
            %                 velocity of nearest 6 vehiclles
            beta_v=zeros(1,n_near);
%             beta_d=zeros(1,n_near);
            for n=1: n_near
                beta_v(n)=atan2(est_near(4,n),est_near(2,n))-atan2(estX(4,p),estX(2,p));     %atan2(yhat,xhat)-atan2(ydot,xdot)
%                 beta_d(n)=atan2(dist_line(2,n),dist_line(1,n))-atan2(vel_curr(2),vel_curr(1));
            end
            idx_comp=[];
            for n1=1:n_near
                if (abs(beta_v(n1))<=betav_thresh) %if distance and velocity angle and ditance angle are all within threshold

                        if (estX(2,p)>0)&&(estX(4,p)>0) %if velocity direction is in 2nd quad
                            if (est_near(1,n1)>estX(1,p)) && (est_near(3,n1)>estX(3,p))
                                idx_comp=[idx_comp; n1];
                                continue;
                                %                             pairs=[pairs [estL(:,p); labels_near(:,n1)]];
                                %                             break;
                            end
                        elseif (estX(2,p)<0)&&(estX(4,p)>0) %if velocity direction is in 3rd quad
                            if (est_near(1,n1)<estX(1,p)) && (est_near(3,n1)>estX(3,p))
                                idx_comp=[idx_comp; n1];
                                continue;
                                %                             pairs=[pairs [estL(:,p); labels_near(:,n1)]];
                                %                             break;
                            end
                        elseif (estX(2,p)<0)&&(estX(4,p)<0) %if velocity direction is in 4th quad
                            if (est_near(1,n1)<estX(1,p)) && (est_near(3,n1)<estX(3,p))
                                idx_comp=[idx_comp; n1];
                                continue;
                                %                             pairs=[pairs [estL(:,p); labels_near(:,n1)]];
                                %                             break;
                            end
                        elseif (estX(2,p)>0)&&(estX(4,p)<0) %if velocity direction is in 1st quad
                            if (est_near(1,n1)>estX(1,p)) && (est_near(3,n1)<estX(3,p))
                                idx_comp=[idx_comp; n1];
                                continue;
                                %                             pairs=[pairs [estL(:,p); labels_near(:,n1)]];
                                %                             break;
                            end
                        end
%                     end
                end
            end
            
            if (~isempty(idx_comp))
                if (length(idx_comp) ==1)
                    %                         if (abs(beta_d(idx_comp)) <= betad_thresh)
                    pairs= [pairs [label_curr; labels_near(:,idx_comp)]];
                    %                         end
                else
                    %                         [~,idx_front]=min(abs(beta_d(idx_comp)));
                    [~,idx_front]=min (dist_near(idx_comp));
                    %                         if (abs(beta_d(idx_front)) <= betad_thresh)
                    
                    pairs= [pairs [label_curr; labels_near(:,idx_front)]];
                    %                         end
                end
            end
            
        end
        %         end
    end

    
end


end