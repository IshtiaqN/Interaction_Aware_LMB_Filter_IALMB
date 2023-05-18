function X= gen_newstate_fn(model,Xd,V)

%nonlinear state space equation (CT model)

% Sigma1 = 0.8;   %larger sigma for distance
Sigma2=7;     %smaller sigma for vel
L= size(Xd,2);

if ~isnumeric(V)
    if strcmp(V,'noise')
        %         V1= Sigma1.*randn(1,L);
        V= Sigma2.*randn(2,L);
    elseif strcmp(V,'noiseless')
        %         V1= zeros(1,L);
        %         V2= zeros(1,L);
        V=zeros(2,L);
    end
end

% V=[V1;V2];
% V=V2;

if isempty(Xd)
    X= [];
else
    X= zeros(size(Xd));
    X(2,:)= Xd(2,:);
    X(4,:)= Xd(4,:);
    X(1,:)= Xd(1,:)+ X(2,:);
    X(3,:)= Xd(3,:) + X(4,:);
    
    %-- add scaled noise
    X= X+ model.B2*V;
    
    
end


