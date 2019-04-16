% This class is called Domain. It plays a role as the boss in the
% builder design pattern.Domain owns everything but does not do everything.
% One object of a class Domain is used to define one problem. 
% LinSysCreater is the CEO of linear system building which supervises the
% worker(class element). Element is the basic builder which produces each
% element of the linear system and then assemle them into a global linear
% system.
classdef Domain < handle
   properties
      Preprocess    % Instance of ToolPack.Preprocessor
      NewtonRaphson % Solver--Newton_Raphson Iterator, the director for elasto-plastic problem
      Postprocess   % Instance array of ToolPack.Postprocessor
      LinSysCrt
      ElemType      % Specify the element type of the problem;
      % 1-plane stress, 2-plane strain, 3-axisymmetric
      ElemDict      % Element dictionary, the builder of stiffness matrix
      NodeDict      % Node dictionary, providing the location arrary
      MatType       % Specify the Material type (Constitutive law)
      % 1-linear elastic, 2-Drucker-Prager, 3-Drucker-Prager/Cap, 
      % 4-Coupled material
      TimestepDict=0.01*ones(10);
      Currtime=0; % The initial time is 0 s.
      NoDofs=0;     % Number of all Dofs
      Predisp       % Applied disp to the boundaries, each row corresponds each (displacement condition)boundary
   end
   events
      TimeChanged 
   end
   
   methods

       function obj=Domain(elemtype,material,varargin) % Construct an object of Domain class
           if nargin>0
           obj.ElemType=elemtype;
           obj.MatType=material;
               if nargin==3
               obj.Predisp=varargin{1};
               end
           end
       end
    
       function set.Preprocess(obj,preprocessor)
           if(isa(preprocessor,'ToolPack.Preprocessor'))  
               obj.Preprocess=preprocessor;
           else
               error('Input must be an instance of Preprocessor');
           end  
       end
       
       function set.Postprocess(obj,postprocessor)
           if(isa(postprocessor,'ToolPack.Postprocessor'))  
               obj.Postprocess=postprocessor;
           else
               error('Input must be an instance of Postprocessor');
           end  
       end
       
       function set.NewtonRaphson(obj,newraph)
           if(isa(newraph,'DomainPack.NewRapItr'))  
               obj.NewtonRaphson=newraph;
           else
               error('Input must be an instance of NewRapItr');
           end  
       end
       
      function set.LinSysCrt(obj,linsyst)
           if(isa(linsyst,'DomainPack.LinSysCreater'))  
               obj.LinSysCrt=linsyst;
           else
               error('Input must be an instance of LinSysCreater');
           end  
       end
       
       function set.TimestepDict(obj,varargin)
           % Extend timestep to initial timestep dictionary if necessary
           if isnumeric(varargin)
               obj.TimestepDict=[obj.TimestepDict,varargin{:}];
           else
               error('TimestepDict can only accept numerica data')
           end
       end
       
       function currtimechange(obj) % event notifier
           obj.notify('Timechanged',DomainPack.TimeStamp(obj));     
       end
       
       % undefined functions 
       updatectime(obj);  %Undefined function to update currenttime
       assignmesh(obj);
       storage(obj,iinc,varargin);
       running(obj,varargin);
       %
   end
end
