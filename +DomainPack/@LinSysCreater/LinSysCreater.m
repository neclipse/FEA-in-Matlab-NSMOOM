classdef LinSysCreater < handle
   properties
       LHS          % Left hand side of the linear system
       LHSO         % last converged left hand side
       RHS          % Right hand side of the linear system
       Drow         % The size of the linear system in row dimension
       Dcol         % The size of the linear system in column dimension
       Unknowns     % The unknowns vector
       TotDisp      % Current relative displacements
       TotDispO     % Last Converged relative displacements
       MatType      % The material type, same as that in Domain class
       ElemType     % The element type, same as that in Domain class
       ElemDict     % The element dictionary created in the domain class
       NodeDict     % The node dictionary created in the domain class
       TotPredisp   % Total prescribed displacement, which will be used for incremental displacement loading
       Predisp      % Applied disp to the boundaries, each row corresponds each (displacement condition) prescribed dof
       BCTables     % The boundary condition table for stress loads
       BCTablet     % The boundary condition table for traction loads
       BCTablen     % The boundary condition table for sparse nodes
       BCTabled     % The boundary condition table for displacement
       EPArea       % The total area of elements which have yielded
   end
   methods
       function obj=LinSysCreater(drow,dcol,elemtype,mattype,elemdict,nodedict,totpredisp,bctables,bctablet,bctablen,bctabled)
           obj.Drow=drow;
           obj.Dcol=dcol;
           obj.ElemType=elemtype;
           obj.MatType=mattype;
           obj.ElemDict=elemdict;       % Handles of all elements
           obj.NodeDict=nodedict;       % Handles of all nodes
           obj.TotPredisp=totpredisp;
           obj.Predisp=totpredisp;      % For the fixed prescribed displacement condition
           obj.BCTables=bctables; 
           obj.BCTablet=bctablet; 
           obj.BCTablen=bctablen;
           obj.BCTabled=bctabled;
           obj.TotDisp=zeros(drow,1);
           obj.TotDispO=zeros(drow,1);
           obj.EPArea=0;
           obj.LHS=zeros(drow,dcol);    % preallocate the size of LHSO for the appbound_v2 at the first iteration
       end
      

       %%-- Declare other methods which are not defined in the main file
       solve(obj,varargin);             % solve the linear system
       crtRHS_v2(obj);                  % creat the right-hand side of the linear system by calculating the load vector
       crtRHS_v3(obj);                  % creat the right-hand side of the linear system by calculating the load vector
       appbound_v2(obj);                % apply boundary condition to the linear system
       appbound(obj);
       upconf(obj);                     % update configuration: incremental displacements and total accumulated displacements
   end
   methods(Abstract)
        crtLHS(obj);                    % creat the left-hand side of the linear system by assembling the element stiffness matrix
   end
end