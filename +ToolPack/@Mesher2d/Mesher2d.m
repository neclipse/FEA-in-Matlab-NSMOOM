% This basic class is to generate a satisfied mesh for the domain geometry
% The whole procedure is made up of three main steps:
% 1. Initially mesh the domain to give nodes and element information with
% distmesh toolbox
% 2. Validate and reorder the initial element vertices
% 3. Setup the Boundary condition table.
classdef Mesher2d < handle
   properties
   % Domain geometry

   % first meshinfo
   p         %[x,y,...] coordinates of every nodes
   t         %[ind1,ind2,ind3,...] element connections 
   % t is ordered in counterclockwise by vertices first and side nodes last 
   q         % mesh quality 
   MT        % material property type of elements
   VT        % type of mesh vertices: 1--corner nodes; 2--side nodes
   end
   properties(Dependent)
      %% second meshinfo 
      % Just to keep the compatibility with other open-source codes
      EToV      % Element to vertices, same as t.    
      VX        % x-coordinates of mesh vertices
      VY        % y-coordinates of mesh vertices
      Totelem   % total number of elements
      Totnodes  % total number of nodes
      Nface     % number of faces of an element
   end
   
   methods(Abstract)
       validate(obj); 
       smooth(obj);
       reorder(obj);
       material(obj);
       nodetype(obj);
   end
   
   methods
       
       function Totelem=get.Totelem(obj)
           Totelem=size(obj.t,1);
       end
              
       function Nface=get.Nface(obj)
           Nface=size(obj.t,2);
       end
              
       function Totnodes=get.Totnodes(obj)
           Totnodes=size(obj.p,1);
       end
       
       function EToV=get.EToV(obj)
           EToV=obj.t;  
       end
       
       function VX=get.VX(obj)
          VX=obj.p(:,1); 
       end
       
       function VY=get.VY(obj)
          VY=obj.p(:,2); 
       end
       
       id=itemize(obj,x,y); % To retrieve the index of a node 
       
%        function savemesh(obj)
%           if isvalid(obj)
%               save('meshfile.mat','obj');
%               disp('Mesher object has been saved in meshfile.mat')
%           else
%               error('The object has been deleted')
%           end
%        end
       
           
   end
    
end
