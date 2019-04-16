classdef Quadmesher < handle
    properties
        p
        t      
        VT
    end
     properties(Dependent)
%%- second meshinfo 
      % Just to keep the compatibility with other open-source codes
      EToV      % Element to vertices, same as t.    
      VX        % x-coordinates of mesh vertices
      VY        % y-coordinates of mesh vertices
      Totelem   % total number of elements
      Totnodes  % total number of nodes
      Nface     % number of faces of an element
     end
    methods
        %Constructor
        function obj=Quadmesher(re,rw,partition,tanstep,radstep1,radstep2,bias1,bias2)
            [ node,element,~,~ ] = mesh( re,rw,partition,tanstep,radstep1,radstep2,bias1,bias2 );  
            obj.p=node;
            obj.t=element;
        end
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
       function nodetype(obj)
          obj.VT=ones(size(obj.p,1),1);
       end
       
       function id=itemize(obj,x,y)
            % This is a method of Mesher2d to retrieve the index of a node
            tol=1e-6;
            id=[0,0];                                % arbitrary condition to go to while loop
            while ~isscalar(id)                      % id is not a scalar: multiple points have been found
            ind= find(abs(obj.VX-x)<1e-5);           % Find the index of nodes with VX==x
            indt=logical(abs(obj.VY(ind)-y)<1e-5);   % Search within the found index for nodes with VY==y
            id=ind(indt);                            % Convert logical value to original index
            tol=tol/10;
            end
       end
    end
end
