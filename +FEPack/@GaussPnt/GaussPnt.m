classdef GaussPnt < handle
    properties
    Xi          % s-coordinate in local parent coordinate system
	Eta         % t-coordinate in local parent coordinate system
	H           % integration weight
    X           % x-coordinates in global cartesian coordinate system
    Y           % y-coordinates in global cartesian coordinate system
    NNodes      % number of Nodes involved in the calculation of gaussian points
    Bmat        % B matrix for this gaussian point
    DetJ        % Determinant of the Jacobian matrix
	ItrStn		% Strain change at current iteration
    DGama       % The plastic multiplier for current iteration 
    ETrial      % Total Elastic trial strain at current iteration
	ElaStn		% Updated Total Elastic strain
	PlaStn		% Updated Total Plastic strain
    EPBar       % The hardening parameter(total)
	Stressc     % Updated current relative stress
	Tangent		% D matrix
    EPFlag      % '1' means elatoplastic, '0' means pure elastic
    SUFail      % '1' means state updating fails, "0" means successes
    ElaStnO     % Last converged total Elastic strain  
    EPBarO      % Last converged total hardening parameter
    PlaStnO     % Last converged total Plastic strain 
    StresscO    % Last converged relative stress 
    EPFlagO     % Last converged Elasto-Plastic flag
    end
    
    methods
		function obj=GaussPnt(xi,eta,h,nnodes)
            if nargin>0
			obj.Xi=xi;
			obj.Eta=eta;
			obj.H=h;
            obj.NNodes=nnodes;             % number of nodes involved in the calculation of gaussian points
            obj.ElaStnO=zeros(4,1);
            obj.PlaStn=zeros(4,1);
            obj.EPBar=0;
            obj.Stressc=zeros(4,1);         % Updated accumulated relativestress, 4*1;
            obj.EPFlag=0;
            obj.PlaStnO=zeros(4,1);
            obj.EPBarO=0;
            obj.EPFlagO=0;
            obj.StresscO=zeros(4,1);
            end
        end
        
		function listra(obj,itrdisp)
            %% IMPORTANT ERROR: THERE IS NO GAUSSIAN WEIGHT BECAUSE THIS IS NO INTEGRATION
            obj.ItrStn=obj.Bmat*itrdisp;  % calculate the contribution of one gaussian point to the element strain
        end
        function initial(obj,inistress,Delastic)% Initialize the elastic strain of the prestressed material
            obj.ElaStnO=Delastic\inistress;
        end
        preparing(obj,X,Y); % Calculate X-,Y- coordinates, B matrix, dJ, and other derivative for the left handside of the linear system
        switching(obj,mode);
    end
    methods(Abstract)
		matsu(obj);
		matct(obj);
	end
end