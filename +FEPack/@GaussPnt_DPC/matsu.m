function  matsu(obj,matprop)
%MATSU Stress State Update method of GaussPnt_DPC
%   Elastic predictor/ Plastic returning map method is employed
%   For every iteration, this method is called to calculate the accumulated stress for current load increment
%   TENSILE STRESS IS DEFINED POSITIVE
%% Initializing        
% retrieve material properties from element class
G=matprop.G;        % G, shear modulus
lamda=matprop.lamda;% first lame constant
xi=matprop.xi;      % parameter for Drucker-Prager yield surface
eta=matprop.eta;    % parameter for Drucker-Prager yield surface
etabar=matprop.etabar; % parameter for non-associative Drucker-Prager flow rule
c0=matprop.c0;      % Initial cohesion
H=matprop.H;        % Hardening modulus
K=lamda+2*G/3;      % K, bulk modulus
% initialize some parameters for this return
epflag=0;
apexflag=0;
epbar=obj.EPBar;    % epbar for current iteration, epbar_sub{n+1}
tds=zeros(4,1);     % Elastic trial deviatoric stress, four components for plane strain problem
elastn=zeros(3,1);
stress=zeros(4,1);  % Updated stress, 4*1;
tol=1e-6;           % returning tolerance
%% Elastic predictor
etrial=obj.ElaStn+obj.ItrStn;   % Last returned elastic strain tensor + strain change at this iteration, 3*1
etv=etrial(1)+etrial(2);        % Elastic trial volumetric strain 
tps=K*etv;                      % Trial Pressure stress
% Trial deviatoric stress
tds([1,2])=2*G*(etrial([1,2])-etv/3);
tds(3)=G*etrial(3);        % G*gama=tau; elastic trial strain is in engineering strain form.
tds(4)=2*G*(-etv/3);       % strain components in the third direction is zero;
% Compute elastic trial stress J2 invariant
SQRJ2T=sqrt(tds(3)^2+0.5*(tds(1)^2+tds(2)^2+tds(4)^2));
cohe=c0+H*epbar;
%% Check plastic admissity
phi=SQRJ2T+eta*tps-xi*cohe;
if cohe~=0
    residual=phi/abs(cohe);
end
if residual>tol
    epflag=1;
end
%% Plastic Return mapping
if epflag==1 
%Return to the smooth cone first
  % Solve the plastic multiplier in closed form for linear
  % hardening Drucker-Prager model. The formula also applies to perfect
  % plastic model, for which H equals to zero.
    dgama=phi/(G+K*eta*etabar+H*xi^2); 
    SQRJ2=SQRJ2T-G*dgama;   % Updated sqrt(J2_sub{n+1}), not trial value
    if SQRJ2>0
        factor=1-G*dgama/SQRJ2T;
    elseif SQRJ2==0
        factor=0;        
    elseif SQRJ2<0
        apexflag=1;
    end
% return to the apex
    if apexflag==1
        depv=(tps-cohe*xi/etabar)/(xi^2*H/(eta*etabar)+K);
        dgama=depv/etabar;
        factor=0;
    end
%% Update stress, strain and epbar
% Update Stress
    ps=tps-K*dgama*etabar;
    stress([1,2,4])=factor*tds([1,2,4])+ps;
    stress(3)=factor*tds(3);
    obj.Stress=stress;
% Update epbar and dgama
    obj.EPBar=epbar+xi*dgama;
    obj.DGama=dgama;
% Update returned elastic (engineering) strain components
    elastn([1,2])=0.5*factor*tds([1,2])/G+ps/(3*K);
    elastn(3)=factor*tds(3)/G;
    delastn=elastn-obj.ElaStn;      % Change in elastic strain
    obj.ElaStn=elastn;
% Save elastic trial strain for the calculation of consistent tangent
% operator
    obj.ETrial=etrial;
% Update returned plastic strain components
    dplastn=obj.ItrStn-delastn;     % Change in plastic strain
    obj.PlaStn=obj.PlaStn+dplastn;  % Updated plastic strain
%% Pure Elastic step
elseif epflag==0
% Update stress
    stress([1,2,4])=tds([1,2,4])+tps;
    stress(3)=tds(3);
    obj.Stress=stress;
% Update strain
    obj.ElaStn=etrial;
    obj.ETrial=etrial;
end
%% Update some algorithmic variables before exit
obj.EPFlag=epflag;
obj.ApexFlag=apexflag;
end

 