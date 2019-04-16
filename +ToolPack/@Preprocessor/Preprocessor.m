classdef Preprocessor < handle
   properties
       Mesher           % an object of Mesher
       Nobound          % number of boundaries
       Disthandle       % the distance handle of the boundaries
       CurLoads         % Current loads applied to the boundaries
       BCmat_line       % boundary condition matrix, its size is nobound* nodofs
       BoundEdge        % indices of corner nodes on a side along the boundary
       BCTable_line
       BCTable_node     % boundary condition table, its size is nonode*4
       BCTable_disp     % boundary condition table for predescribed displacement
       BCTable_stress   % boundary condition table for predescribed stress tensor
       BCTable_traction % boundary condition table for predescribed stress tensor
       % First coloumn is the index of boundary, next two coloumns are 
       % indices of nodes on a side along the boundary, last several
       % coloumns are the boundary condition type of each kind of dof
    
   end
   
   methods
       
       function obj=Preprocessor(nobound,disthandle,BCmat_line,varargin)
           obj.Nobound=nobound;
           obj.Disthandle=disthandle;
           obj.BCmat_line=BCmat_line;
           if nargin==5
           obj.BCTable_node=varargin{1};
           obj.CurLoads=varargin{2};
           end
           % nobound: The number of boundaries
           % Disthandle: The handle of distance function of each boundary
           % in the order of NoBound
           % BCmat_line: The boundary condition type matrix, each row
           % represents one boundary, each column represents one dof
                % [xdisp,ydisp and loads], MAKE SURE THE LAST COLUMN IS FOR LOADS CONDITION
                % '0' means no boundary condition;
                % '1' means nodal value like (displacement or nodal loads)
                % '2' means constant distributing stress loads in cartesian
                % coordinate system, like in-situ stress to the outer boundary
                % '3' means traction boundary condition, [Tnormal;Tshear]. 
           % BCmat_node: boudnary condition type matrix of each node with 
           % special care: [idof,id,x-coord,y-coord,disp]

       end
      
       function preprocess(obj)
           if obj.Mesher.Nface==3
           obj.Mesher.validate;
           obj.Mesher.reorder;

           end
           obj.Mesher.nodetype;
           obj.BoundEdge=boundedges2(obj.Mesher.p,obj.Mesher.t);
           obj.constrBCTable;
           save('preprocessor.mat','obj');
       end    
       constrBCTable(obj);
   end
end
