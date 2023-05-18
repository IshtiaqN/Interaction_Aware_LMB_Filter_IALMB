function gz_vals= compute_likelihood(model,z,X)

% compute likelihood vector g= [ log_g(z|x_1), ... , log_g(z|x_M) ] -
% this is for bearings and range case with additive Gaussian noise

M= size(X,2);
P= X([1 3],:);
Phi= zeros(2,M);
Phi(1,:)= P(1,:); %atan2(P(1,:),P(2,:));
Phi(2,:)= P(2,:); %sqrt(sum(P.^2));
e_sq= sum( (diag(1./diag(model.D))*(repmat(z,[1 M])- Phi)).^2 );
gz_vals= exp(-e_sq/2 - log(2*pi*prod(diag(model.D))));
% if max(gz_vals)>0
%     disp(max(gz_vals))
% end
% gz_vals = exp(-0.5 * ( model.z_dim * log(2*pi)) - log(model.Observation_Noise.Determinant_R) ...
  %     - 0.5 * dot(repmat(z,[1 size(X,2)])-model.H * X,model.Observation_Noise.Inverse_R*(repmat(Z,[1 size(X,2)])-model.H * X)));

% function gz_vals= compute_likelihood(model,Z,X)
% 
% % Convert the predicted density particles from world coordinate system to image
% % coordinate system
% % Variances for each of the camera should be different. Expand the model
% % accordingly. There should be one birth model as we do it in the
% % prediction step.
% 
% [~, X4] = projectToImage(X(1,:),X(3,:),Camera_Parameters,X(5,:));
% [X(1,:), X(3,:)] = projectToImage(X(1,:),X(3,:),Camera_Parameters,zeros(size(X(5,:))));
% X(5,:) = abs(X4 - X(3,:));
% % model.Observation_Noise{Index}.Determinant_R
% % repmat(Z,[1 size(X,2)])
% % model.H * X
% % (repmat(Z,[1 size(X,2)])-model.H * X)
% %Based on equations in labeled RFS and the Bayes multi-target tracking filter

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  gz_vals = exp(-0.5 * ( model.z_dim * log(2*pi)) - log(model.Observation_Noise.Determinant_R) ...
%         - 0.5 * dot(repmat(Z,[1 size(X,2)])-model.H * X,model.Observation_Noise.Inverse_R*(repmat(Z,[1 size(X,2)])-model.H * X)));
%disp(max(gz_vals));
   % 
% 
% %Based on coordinated turn likelihood 
% % e_sq= sum( (diag(1./diag(model.Observation_Noise{Index}.D))*(repmat(Z,[1 size(X,2)])- model.H*X)).^2 );
% % gz_vals= exp(-((e_sq/2)) - (2*pi*prod(diag(model.Observation_Noise{Index}.D))));
% 
% %Average of likelihoods for each dimension in Z
% %  gz_vals= sum(exp(-10^-10*((repmat(Z,[1 size(X,2)])- model.H*X)./(2*repmat(diag(model.Observation_Noise.R),[1 size(X,2)]))))...
% %      ./(sqrt(2*pi*repmat(diag(model.Observation_Noise.R),[1 size(X,2)]))),1)/model.z_dim;
% 
% %Based on multi-variate Gaussian - average for each dimension in Z
% % gz_vals = sum((1/((2*pi)^(model.z_dim/2)*sqrt(model.Observation_Noise{Index}.Determinant_R))) * ...
% %     exp(- 0.5 * (repmat(Z,[1 size(X,2)])-model.H*X) .* (model.Observation_Noise{Index}.Inverse_R * (repmat(Z,[1 size(X,2)])-model.H*X)))) ...
% %     /model.z_dim;
% 
% %Based on multiplying three Gaussians assuming that independent covariences
% % e_sq1 = (1./(2*model.Observation_Noise.R(1,1)*power((repmat(Z(1,:),[1 size(X,2)])-X(1,:)),2)));
% % e_sq2 = (1./(2*model.Observation_Noise.R(2,2)*power((repmat(Z(2,:),[1 size(X,2)])-X(2,:)),2)));
% % e_sq3 = (1./(2*model.Observation_Noise.R(3,3)*power((repmat(Z(3,:),[1 size(X,2)])-X(3,:)),2)));
% % gz_vals = (1/(sqrt(2*pi*prod(diag(model.Observation_Noise.D))))) * exp(-e_sq1-e_sq2-e_sq3);
% 
% % for i  = 1 : size(X(1,:),2)
% % 	line([X(1,i) X(1,i)],[X(3,i) X4(i)],'LineWidth',2);
% % end
% %          
% %          pause(1);
% %          hold off;
% 
% % hold on;
% % for i = 1 : size(Z,2)
% % line([Z(1,i) Z(1,i)],[(Z(2,i)) (Z(2,i)-Z(3,i))],'LineWidth',2,'Color','r');
% % end
% % for i = 1 : size(X,2)
% % line([X(1,i) X(1,i)],[X(3,i) (X(3,i)+X(5,i))],'LineWidth',2);
% % end
% % hold off;
% % pause(0.5);
% 
% 
% 
% 
% 
% 
% %   gz_vals = (1./(sqrt(2 * pi * model.Observation_Noise{Index}.R))) *...
% %         exp (-(repmat(Z,[1 size(X,2)]) - model.H * X)./(2 * model.Observation_Noise{Index}.R));
