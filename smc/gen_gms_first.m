function X= gen_gms_first(Vi,Z,num_par)
% generate samples from Gaussian mixture intensity function for the first
% frame. For subsequent frames, the 'gen_gms.m' function is used from the
% '_common' directory
% 


    
m(:,1)=[Z(1); Vi(1); Z(2); Vi(2)];


    w=1;
    x_dim=size(m,1);
    X=zeros(x_dim,num_par);
    
    %std dev of Gaussians
    Vi_total=sqrt((Vi(1)^2) + (Vi(2))^2 );
    
    if (Vi_total <20)
        B(:,:,1)= diag([5; 5; 5; 5 ]);
    else
        B(:,:,1)= diag([5; 10; 5; 10 ]);
    end
    P(:,:,1)= B(:,:,1)*B(:,:,1)';
    
    nc= length(w);
    
    comps= randsample(1:nc,num_par,true,w);
    
    ns= zeros(nc,1);
    for c=1:nc
        ns(c)= nnz(comps==c);
    end
    
    startpt= 1;
    for i=1:nc
        endpt= startpt+ns(i)-1;
        X(:,startpt:endpt)= gen_mvs(m(:,i),P(:,:,i),ns(i));
        startpt= endpt+1;
    end
    
    function X= gen_mvs(m,P,ns)
    
    U= chol(P); X= repmat(m,[1 ns]) + U*randn(length(m),ns);
