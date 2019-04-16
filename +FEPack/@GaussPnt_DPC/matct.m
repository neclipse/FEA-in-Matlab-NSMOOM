function  matct( obj, matprop )
%MATCT Method of GaussPnt_DP to calculate the tangent operator consistent
%with the last converged stress returing
%   This method will use elastic trial strain and dgama for last returning
%   mapping as inputs, and output the Tangent property of the object
%% Initializing and retriving material properties
Is=diag([1 1 0.5]); % The symmetric identity tensor in array form
I=[1 1 0];          % The identity tensor in array form
etds=zeros(3,1);    % elastic trial deviatoric strain tensor in array form
dgama=obj.DGama;
etrial=obj.ETrial;
epflag=obj.EPFlag;
apexflag=obj.ApexFlag;
% retrieve material properties
G=matprop.G;        % G, shear modulus
lamda=matprop.lamda;% first lame constant
xi=matprop.xi;      % parameter for Drucker-Prager yield surface
eta=matprop.eta;    % parameter for Drucker-Prager yield surface
etabar=matprop.etabar; % parameter for non-associative Drucker-Prager flow rule
H=matprop.H;        % Hardening modulus
K=lamda+2*G/3;      % K, bulk modulus
%% Tangent consistent with the apex
if epflag
    if apexflag
        alpha=xi/etabar;
        beta=xi/eta;
        afact=K*(1-K/(K+alpha*beta*H));
        Dmat=afact*(I'*I);
%% Tangent consistent with the smooth cone
    else
% set up elastic trial deviatoric strain (physical)
        etv=etrial(1)+etrial(2);
        etds([1,2])=etrial([1,2])-etv/3;
        etds(3)=etrial(3)/2;
        etdsnorm=sqrt(etds(1)^2+etds(2)^2+2*etds(3)^2);
% unit deviatoric flow vector
        if etdsnorm
            etdsuni=etds/etdsnorm; % unit vector of etds
        else
            etdsuni=zeros(3,1);      
        end
% Assemble tangent operator
        aconst=1/(G+K*eta*etabar+xi^2*H);   % 'A' constant
        afact=2*G*(1-dgama/(sqrt(2)*etdsnorm));
        bfact=2*G*(dgama/(sqrt(2)*etdsnorm)-G*aconst);
        cfact=-sqrt(2)*G*K*aconst;
        dfact=K*(1-K*eta*etabar*aconst);
    % deviatoric tensor in array form
    Id=Is-(I'*I)/3;
    Dmat=afact*Id+bfact*(etdsuni*etdsuni')+cfact*(eta*(etdsuni*I)+...
        etabar*(I'*etdsuni'))+dfact*(I'*I);
    end
else
%% Elasticity matrix
Dmat=[lamda+2*G,lamda,0;lamda,lamda+2*G,0;0,0,G];
end
obj.Tangent=Dmat;
end

