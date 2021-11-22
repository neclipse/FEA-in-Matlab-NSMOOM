% This is the main script of the proposed elastoplastic approach for the 
% wellbore stability problem. It will calculate the deformation of the rock
% around the horiztontal wellbore and determine if a failure will happen.

%%  Importing packages
% -- Initialize the work spac
clear; clc;
% Import class packages 
import ToolPack.*;                          % Complimentary tool classes, like Preprocessor
import FEPack.*;                            % Elementary level classes, like element class, node class and gausspnt class
import DomainPack.*;                        % Domain level classes, like Domain, LinSysCrt, NewRapItr
% --Add the other complimentary functions folders to the search path
addpath('.\distmesh');
addpath('.\Utility');
%% Set up the model, Domain
%% --Preparation for data
% -- Load conditions
global  G lamda K xi eta etabar epbar c0 H Delastic inistress;   
sgmH=-48.51;                                % Maximum horizontal principal stress(MPa), tensile is positive
sgmh=-43.12;                                % Minimum horizontal principal stress(MPa)
sgmv=-71.87;                                % Vertical principal stress(MPa)
ppi=17.3;                                   % initial pore pressure(MPa)
pwb=15.92;                                  % wellbore pressure(MPa)
% Initial effective stress state, sgmx,sgmy,tauxy,sgmz
inistress=[sgmh;sgmv;0;sgmH];   % The initial stress state of any point within the domain is the effective in-situ stress state; 
curloads1=[sgmh,sgmv,0,sgmH];
curloads2=[pwb,0];                      % Normal traciton is wellbore pressure, shear traction is zero.
curloads={curloads1;curloads2};
% When the support provided by the drilled-out rock is replaced by the
% wellbore pressure
% -- Rock Properties
E=22821;                                    % Young's Modulus (MPa)
nu=0.33;                                    % Poission ratio
c0=6;                                   % Cohesion(Mpa)
phi=30*pi/180;                            % internal friction angle
psi=30*pi/180;                            % shear dilatant angle
H=10;                                      % Hardening modulus(MPa), c=c0+H*epbar;
G=0.5*E/(1+nu);                             % Shear modulus,in the unit of Mpa
lamda=2*nu*G/(1-2*nu);                      % The first Lame constant, in the unit of MPa
K=lamda+2*G/3;                              % K, bulk modulus
xi=3/(sqrt(9+12*tan(phi)^2));               % parameter for Drucker-Prager yield surface
eta=tan(phi)*xi;                            % parameter for Drucker-Prager yield surface
etabar=3*tan(psi)/(sqrt(9+12*tan(psi)^2));  % parameter for non-associative Drucker-Prager flow rule
epbar=0;                                    % initial plastic strain
Delastic=[lamda+2*G,lamda,0,lamda;lamda,lamda+2*G,0,lamda;0,0,G,0;lamda,lamda,0,lamda+2*G];
yield(inistress);                           % Check the yield condition at initial stress state
%% -- Domain
predisp=[0;0];                              % Model is constrained by prescribed displaceemnt
% Set the domain with plane strain, DP material, precribed displacements to boundaries
Wb=Domain(2,1,predisp); 
%% --Preprocessor
re=16.5;                                    % The imaginary reservoir raidus
rw=0.165;                                   % The actual wellbore radius
partition=0.8;
tanstep=18;                                 % The number of elements along tangential direction
radstep1=35;                                % The number of elements along radial direction in the inner part
radstep2=15;                                % The number of elements along radial direction in the outer part
bias1=15;                                   % The bias ratio: the ratio between the largest element size and the smallest one
bias2=15;
fb1=@(p) dcircle(p,0,0,re);                 % The external reservoir boundary
fb2=@(p) dcircle(p,0,0,rw);                 % The internal wellbore boundary
fb3=@(p) p(:,2);                            % The x-axis
fb4=@(p) p(:,1);                            % The y-axis
% BCTable_node=[0 0 0.5 0  0 ;
%               0 0 25  0  0 ;
%               0 0 0  0.5 0 ;
%               0 0 0  25  0 ];
BCTable_node=[];
preprocessor=Preprocessor(4,{fb1;fb2;fb3;fb4},[0,0,2;0,0,3;0,1,0;1,0,0],BCTable_node,curloads);
wellbore=Quadmesher(re,rw,partition,tanstep,radstep1,radstep2,bias1,bias2);
preprocessor.Mesher=wellbore;
preprocessor.preprocess;
Wb.Preprocess=preprocessor;                 % Assign the defined preprocessor to a property of the Wb object                    
% Meshing: The generated coordinates are defined as the initial location of
% every nodes, further deformation is defined with respect to this set of coordinates.
Wb.assignmesh;
% -- Creating a sparse linear system creater
spa=SparseSysCreater(Wb.NoDofs,Wb.NoDofs,Wb.ElemType,Wb.MatType,...
    Wb.ElemDict,Wb.NodeDict,Wb.Predisp,Wb.Preprocess.BCTable_stress,...
    Wb.Preprocess.BCTable_traction,Wb.Preprocess.BCTable_node,...
    Wb.Preprocess.BCTable_disp);
Wb.LinSysCrt=spa;                           % Assign spa to a property of the Wb object
%% -- Newton-Raphson Iterator
iniincrem=1;                              % initial increment size
inctype=1;                                  % inctype: 1-load increments; 2- displacement increments
% The following three parameters are optional setting to control the speed
% and the accuracy of the Newton-Raphson algorithm. If one is not sure the
% impact of the setting, one can leave them blank.
maxinc=100;
maxitr=9;
tol=1E-9;
newraph=NewRapItr(inctype,iniincrem,spa,maxinc,maxitr,tol);  
Wb.NewtonRaphson=newraph;
clear spa newraph wellbore preprocessor;    % Delete redundant copy of handle object
%% Running the simulation
% -- Begin loop over load increments
tic;                                        % set a timer
% Wb.NewtonRaphson.returning;
% savemode defines the how often the results are saved: 1--means every increment; 2--means every two; n--every n increments
savemode=1;                                 
Wb.running(savemode);
toc;
%% Postprocessing
%example of postprocessing
radstep=radstep1+radstep2;
nodestruct=[tanstep+1,radstep+1];           % This is to reshape nodal variables
pointstruct=[tanstep,radstep];              % This is to reshape gaussian variables, only one gaussian point is extracted from one element
% plot all contour figures without setting the number of contour lines
Wb.Postprocess(end).painter(nodestruct,pointstruct);   
 



