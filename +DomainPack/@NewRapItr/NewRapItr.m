classdef NewRapItr < handle
   properties
       LinSysCrt        % Class member: Linear system creator and solver
       IncType          % Increment type: 1-load increments; 2-displacement
       IInc=1;          % Index of current load increment
       IItr=0;          % current iteration number
       IniIncrem        % Initial increment size
       Increments       % Load increments, accumulate percentage of whole load
       MaxInc=100;      % Control: MAXIMUM number of Increments
       MaxItr=9;        % Control: MAXIMUM Iteration number
       Tolerance=1E-9;  % Tolerance for load vector convergence criteria
       ConvFlag=0;      % Convergence flag
       DivFlag=0;       % Divergence flag
       Ratio            % Ratio: the  norm of the residual to the external load vector
       ResMax           % Maximum nodal residual load
       Dim              % Dimension of load vector
       IntLoadVec 		% Global relative internal load vector for newton-raphson iteration
       ExtLoadVec		% Global relative external load vector for newton-raphson iteration
       FullExtLoad      % Full global relative external load vector;
       IntLoadVecO      % Last Converged internal load vector
       IncCutFlag=0;    % Flag for the increment cutting method
   end 
   properties(Dependent)
       NoInc            % Number of increments
       ResLoadVec       % Global residual load vector
   end

   methods
       function obj=NewRapItr(inctype,iniincrem,linsyscreater,varargin)
           obj.IncType=inctype;
           obj.IniIncrem=iniincrem;
           obj.LinSysCrt=linsyscreater;
           obj.Dim=2*length(linsyscreater.NodeDict);
           obj.IntLoadVec=zeros(obj.Dim,1);
           obj.ExtLoadVec=zeros(obj.Dim,1);   
           obj.IntLoadVecO=zeros(obj.Dim,1);
           if nargin>3
           obj.MaxInc=varargin{1};
           obj.MaxItr=varargin{2};
           obj.Tolerance=varargin{3};
           end
           % Generate the increments array
           obj.incarray(iniincrem);
       end
       function incarray(obj,iniincrem)
           % Generate the increments array
           step=iniincrem/10;
           obj.Increments=iniincrem:step:1;
           if obj.Increments(end)<1
               obj.Increments=[obj.Increments,1];
           end
       end
       function NoInc=get.NoInc(obj)
          NoInc=length(obj.Increments); 
       end
       function ResLoadVec=get.ResLoadVec(obj)
          ResLoadVec=obj.ExtLoadVec-obj.IntLoadVec; 
       end
       function set.LinSysCrt(obj,linsyscreater)
           if(isa(linsyscreater,'DomainPack.LinSysCreater'))  
               obj.LinSysCrt=linsyscreater;
           else
               error('Input must be an instance of LinSyscreater');
           end          
       end
       initialize_v1_E(obj);    % Assume the material at the initial state is pure elastic
       returning(obj);          % Main plastic returning method: loop over equilibrium equation
       intforcer(obj);          % Calulate the internal force vector for all elements
       converger(obj);          % Determine the convergenence flag for the domain
       autoincrem(obj,mode);  % Automatically adjust the size of the increments
       % IMPORTANT :REMEMBER TO ASSIGN CORRECT INPUT AND OUTPUT NUMBER IN
       % DECLARING THE FUNCTION NAME ONLY
       switching(obj,mode);     % switch between current value and last converged value 
       epnotifier(obj);
   end 

end