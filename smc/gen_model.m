function model= gen_model

%basic parameters
model.x_dim= 4;   %dimension of state vector
model.z_dim= 2;   %dimension of observation vector
model.v_dim= 2;   %dimension of process noise
model.w_dim= 2;   %dimension of observation noise

% dynamical model parameters (NCV model)
%these parameters are in pixels
model.T = 1;        %sampling period
model.sigma_vel= 1;
model.bt= model.sigma_vel*[ (model.T^2)/2; model.T ];
model.B2= [ model.bt zeros(2,1); zeros(2,1) model.bt ];
model.B= eye(model.v_dim);
model.Q= model.B*model.B';

% survival/death parameters
model.P_S= .99;
model.Q_S= 1-model.P_S;

% Birth parameters (LMB birth model)
model.T_birth= 32;         %no. of LMB birth terms
model.L_birth= zeros(model.T_birth,1);                                          %no of Gaussians in each LMB birth term
model.r_birth= zeros(model.T_birth,1);                                          %prob of birth for each LMB birth term
model.w_birth= cell(model.T_birth,1);                                           %weights of GM for each LMB birth term
model.m_birth= cell(model.T_birth,1);                                           %means of GM for each LMB birth term
model.B_birth= cell(model.T_birth,1);                                           %std of GM for each LMB birth term
model.P_birth= cell(model.T_birth,1);                                           %cov of GM for each LMB birth term

%no of Gaussians in birth terms
    model.L_birth(1)=1;
    model.L_birth(2)=1;
    model.L_birth(3)=1;
    model.L_birth(4)=1;
    model.L_birth(5)=1;
    model.L_birth(6)=1;
    model.L_birth(7)=1;
    model.L_birth(8)=1;
    model.L_birth(9)=1;
    model.L_birth(10)=1;
    model.L_birth(11)=1;
    model.L_birth(12)=1;
    model.L_birth(13)=1;
    model.L_birth(14)=1;
    model.L_birth(15)=1;
    model.L_birth(16)=1;
    model.L_birth(17)=1;
    model.L_birth(18)=1;
    model.L_birth(19)=1;
    model.L_birth(20)=1;    
    model.L_birth(21)=1;    
    model.L_birth(22)=1;
    model.L_birth(23)=1;
    model.L_birth(24)=1;
    model.L_birth(25)=1;
    model.L_birth(26)=1;
    model.L_birth(27)=1;
    model.L_birth(28)=1;
    model.L_birth(29)=1;
    model.L_birth(30)=1;
    model.L_birth(31)=1;
    model.L_birth(32)=1;

    
    % Probabilities of birth components
    model.r_birth(1)=0.2;
    model.r_birth(2)=0.2;
    model.r_birth(3)=0.2;
    model.r_birth(4)=0.2;
    model.r_birth(5)=0.2; 
    model.r_birth(6)=0.2; 
    model.r_birth(7)=0.2;
    model.r_birth(8)=0.2;
    model.r_birth(9)=0.2;
    model.r_birth(10)=0.2;
    model.r_birth(11)=0.2;
    model.r_birth(12)=0.2;
    model.r_birth(13)=0.2;
    model.r_birth(14)=0.2;
    model.r_birth(15)=0.2;
    model.r_birth(16)=0.2;
    model.r_birth(17)=0.2;
    model.r_birth(18)=0.2;
    model.r_birth(19)=0.2;
    model.r_birth(20)=0.2;
    model.r_birth(21)=0.2;
    model.r_birth(22)=0.2;
    model.r_birth(23)=0.2;
    model.r_birth(24)=0.2;
    model.r_birth(25)=0.2;
    model.r_birth(26)=0.2;
    model.r_birth(27)=0.2;
    model.r_birth(28)=0.2;
    model.r_birth(29)=0.2;
    model.r_birth(30)=0.2;
    model.r_birth(31)=0.2;
    model.r_birth(32)=0.2;

    
    %weight of Gaussians - must be column_vector
    model.w_birth{1}(1,1)= 1;
    model.w_birth{2}(1,1)= 1;
    model.w_birth{3}(1,1)= 1;
    model.w_birth{4}(1,1)= 1;
    model.w_birth{5}(1,1)= 1;
    model.w_birth{6}(1,1)= 1;
    model.w_birth{7}(1,1)= 1;
    model.w_birth{8}(1,1)= 1;
    model.w_birth{9}(1,1)= 1;
    model.w_birth{10}(1,1)= 1;
    model.w_birth{11}(1,1)= 1;
    model.w_birth{12}(1,1)= 1;
    model.w_birth{13}(1,1)= 1;
    model.w_birth{14}(1,1)= 1;
    model.w_birth{15}(1,1)= 1;
    model.w_birth{16}(1,1)= 1;
    model.w_birth{17}(1,1)= 1;
    model.w_birth{18}(1,1)= 1;
    model.w_birth{19}(1,1)= 1;
    model.w_birth{20}(1,1)= 1;
    model.w_birth{21}(1,1)= 1;
    model.w_birth{22}(1,1)= 1;
    model.w_birth{23}(1,1)= 1;
    model.w_birth{24}(1,1)= 1;
    model.w_birth{25}(1,1)= 1;
    model.w_birth{26}(1,1)= 1;
    model.w_birth{27}(1,1)= 1;
    model.w_birth{28}(1,1)= 1;
    model.w_birth{29}(1,1)= 1;
    model.w_birth{30}(1,1)= 1;
    model.w_birth{31}(1,1)= 1;
    model.w_birth{32}(1,1)= 1;


    
       %mean of Gaussians
    model.m_birth{1}(:,1)=[20; 0; 920; 0];   %botom left entrance
    model.m_birth{2}(:,1)=[20; 0; 955; 0];
    model.m_birth{3}(:,1)=[20; 0; 975; 0];
    model.m_birth{4}(:,1)=[20; 0; 1000; 0 ];
    
    model.m_birth{5}(:,1)=[665; 0; 1060; 0 ];   %bottom second entrance
    model.m_birth{6}(:,1)=[685; 0; 1060; 0 ];
    model.m_birth{7}(:,1)=[705; 0; 1060; 0 ];
    model.m_birth{8}(:,1)=[725; 0; 1060; 0 ];
    
    model.m_birth{9}(:,1)=[910; 0; 1050; 0 ];   %bottom centre
    model.m_birth{10}(:,1)=[930; 0; 1050; 0 ];
    model.m_birth{11}(:,1)=[950; 0; 1050; 0 ];
    
    model.m_birth{12}(:,1)=[1880; 0; 1065; 0 ];    %bottom right
    model.m_birth{13}(:,1)=[1900; 0; 1065; 0 ];
    model.m_birth{14}(:,1)=[1905; 0; 1060; 0 ];
    model.m_birth{15}(:,1)=[1910; 0; 1045; 0 ];
    
    model.m_birth{16}(:,1)=[1165; 0; 20; 0 ];    %top right
    model.m_birth{17}(:,1)=[1150; 0; 20; 0 ];
    model.m_birth{18}(:,1)=[1135; 0; 20; 0 ];
    model.m_birth{19}(:,1)=[1110; 0; 20; 0 ];
    
    model.m_birth{20}(:,1)=[1005; 0; 30; 0 ];  %top centre
    model.m_birth{21}(:,1)=[990; 0; 30; 0 ];
    model.m_birth{22}(:,1)=[980; 0; 30; 0 ];
    
    model.m_birth{23}(:,1)=[125; 0; 25; 0 ];     %top left
   
    model.m_birth{24}(:,1)=[985; 0; 255; 10 ];
    model.m_birth{25}(:,1)=[930; 0; 760; -10 ];
    model.m_birth{26}(:,1)=[1330; 0; 790; 0 ];
    model.m_birth{27}(:,1)=[1665; 0; 810; 0 ];
    model.m_birth{28}(:,1)=[1230; 0; 355; 0 ];
    model.m_birth{29}(:,1)=[620; 0; 385; 0 ];
    model.m_birth{30}(:,1)=[280; 0; 295; 0 ];
    model.m_birth{31}(:,1)=[415; 0; 620; 0 ];
    model.m_birth{32}(:,1)=[575; 0; 855; 0 ];

    
    %std of Gaussians
    model.B_birth{1}(:,:,1)= diag([15; 15; 15; 15  ]);       
    model.B_birth{2}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{3}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{4}(:,:,1)= diag([15; 15; 15; 15  ]);
    
    model.B_birth{5}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{6}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{7}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{8}(:,:,1)= diag([15; 15; 15; 15  ]);
    
    model.B_birth{9}(:,:,1)= diag([15; 15; 20; 15  ]);
    model.B_birth{10}(:,:,1)= diag([15; 15; 20; 15  ]);
    model.B_birth{11}(:,:,1)= diag([15; 15; 20; 15  ]);
    
    model.B_birth{12}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{13}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{14}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{15}(:,:,1)= diag([15; 15; 15; 15  ]);
    
    model.B_birth{16}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{17}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{18}(:,:,1)= diag([15; 15; 15; 15  ]);
    model.B_birth{19}(:,:,1)= diag([15; 15; 15; 15  ]);
    
    model.B_birth{20}(:,:,1)= diag([15; 15; 20; 15  ]);
    model.B_birth{21}(:,:,1)= diag([15; 15; 20; 15  ]);
    model.B_birth{22}(:,:,1)= diag([15; 15; 20; 15  ]);
    
    model.B_birth{23}(:,:,1)= diag([15; 15; 15; 15  ]);
    
    model.B_birth{24}(:,:,1)= diag([25; 5; 50; 10  ]);
    model.B_birth{25}(:,:,1)= diag([30; 5; 60; 10  ]);
    model.B_birth{26}(:,:,1)= diag([110; 10; 90; 10  ]);
    model.B_birth{27}(:,:,1)= diag([150; 10; 130; 10  ]);
    model.B_birth{28}(:,:,1)= diag([140; 10; 125; 10  ]);
    model.B_birth{29}(:,:,1)= diag([95; 10; 105; 10  ]);
    model.B_birth{30}(:,:,1)= diag([150; 10; 140; 10  ]);
    model.B_birth{31}(:,:,1)= diag([120; 10; 100; 10  ]);
    model.B_birth{32}(:,:,1)= diag([140; 10; 140; 10  ]);
    

    
    %cov of Gaussians
    model.P_birth{1}(:,:,1)= model.B_birth{1}(:,:,1)*model.B_birth{1}(:,:,1)';
    model.P_birth{2}(:,:,1)= model.B_birth{2}(:,:,1)*model.B_birth{2}(:,:,1)';      
    model.P_birth{3}(:,:,1)= model.B_birth{3}(:,:,1)*model.B_birth{3}(:,:,1)';
    model.P_birth{4}(:,:,1)= model.B_birth{4}(:,:,1)*model.B_birth{4}(:,:,1)';
    model.P_birth{5}(:,:,1)= model.B_birth{5}(:,:,1)*model.B_birth{5}(:,:,1)';
    model.P_birth{6}(:,:,1)= model.B_birth{6}(:,:,1)*model.B_birth{6}(:,:,1)';
    model.P_birth{7}(:,:,1)= model.B_birth{7}(:,:,1)*model.B_birth{7}(:,:,1)';
    model.P_birth{8}(:,:,1)= model.B_birth{8}(:,:,1)*model.B_birth{8}(:,:,1)';
    model.P_birth{9}(:,:,1)= model.B_birth{9}(:,:,1)*model.B_birth{9}(:,:,1)';
    model.P_birth{10}(:,:,1)= model.B_birth{10}(:,:,1)*model.B_birth{10}(:,:,1)';
    model.P_birth{11}(:,:,1)= model.B_birth{11}(:,:,1)*model.B_birth{11}(:,:,1)';
    model.P_birth{12}(:,:,1)= model.B_birth{12}(:,:,1)*model.B_birth{12}(:,:,1)';
    model.P_birth{13}(:,:,1)= model.B_birth{13}(:,:,1)*model.B_birth{13}(:,:,1)';
    model.P_birth{14}(:,:,1)= model.B_birth{14}(:,:,1)*model.B_birth{14}(:,:,1)';
    model.P_birth{15}(:,:,1)= model.B_birth{15}(:,:,1)*model.B_birth{15}(:,:,1)';
    model.P_birth{16}(:,:,1)= model.B_birth{16}(:,:,1)*model.B_birth{16}(:,:,1)';
    model.P_birth{17}(:,:,1)= model.B_birth{17}(:,:,1)*model.B_birth{17}(:,:,1)';
    model.P_birth{18}(:,:,1)= model.B_birth{18}(:,:,1)*model.B_birth{18}(:,:,1)';
    model.P_birth{19}(:,:,1)= model.B_birth{19}(:,:,1)*model.B_birth{19}(:,:,1)';
    model.P_birth{20}(:,:,1)= model.B_birth{20}(:,:,1)*model.B_birth{20}(:,:,1)';
    model.P_birth{21}(:,:,1)= model.B_birth{21}(:,:,1)*model.B_birth{21}(:,:,1)';
    model.P_birth{22}(:,:,1)= model.B_birth{22}(:,:,1)*model.B_birth{22}(:,:,1)';
    model.P_birth{23}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{24}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{25}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{26}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{27}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{28}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{29}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{30}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{31}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';
    model.P_birth{32}(:,:,1)= model.B_birth{23}(:,:,1)*model.B_birth{23}(:,:,1)';


% observation model parameters 
model.D= diag([ 3; 3 ]);      %std for angle and range noise
model.R= model.D*model.D';              %covariance for observation noise

% detection parameters
model.P_D= .995;   %probability of detection in measurements
model.Q_D= 1-model.P_D; %probability of missed detection in measurements

% clutter parameters
model.lambda_c= 6;                             %poisson average rate of uniform clutter (per scan)
model.range_c= [ 0 1920; 0 1080];          %uniform clutter on r/theta
model.pdf_c= 1/prod(model.range_c(:,2)-model.range_c(:,1)); %uniform clutter density

