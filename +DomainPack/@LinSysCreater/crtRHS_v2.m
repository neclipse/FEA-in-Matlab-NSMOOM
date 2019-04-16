function crtRHS_v2( obj )
%CRTRHS_V2 Create the right hand side of the linear system
%   This function include integration and assembly
%   This new version is compatible with new BCTable_load 
FFG=zeros(obj.Drow,1);
nonodes=obj.ElemDict(1).NoNodes; %   nonodes: the number of nodes invloved in the element stiffness matrix
[~,Nline_xi]=lineshape(nonodes,1);
n=length(Nline_xi); % An indirect way to decide the number of nodes along a side of element
if nonodes==3 || nonodes==6 % For triangular elements
    [xx,ww]=GaussQuad(1,1);% calculating gauss points along a line from 0 to 1
elseif nonodes==4 || nonodes==8 % For rectangular elements
    [xx,ww]=GaussQuad(1);% calculating gauss points along a line from -1 to 1
end
table=obj.BCTablel;             % BCTable_load: node indices and side-wise loads
for i=1:size(table,1)
      fe=zeros(2*n,1);
      locarray=zeros(2*n,1);
      X=[obj.NodeDict(table(i,1:n)).X]; % X is a row vector
      % X is the x coordinates list of the nodes along the boundary side
      Y=[obj.NodeDict(table(i,1:n)).Y]; 
      load=table(i,(n+1):end);
      % loop over gaussian points
      for j=1:length(xx)
         xi=xx(j);
         [Nline,Nline_xi]=lineshape(nonodes,xi);
         x_xi=Nline_xi*X';
         y_xi=Nline_xi*Y';
         normal=[y_xi,0;0,-x_xi];    % THIS FORMULA IS DEBATABLE for Triangle Elements
         fet=Nline'*normal*load';                    % THIS FORMULA IS DEBATABLE for Triangle Elements
         fe=fe+ww(j)*fet;
      end
      %% Assembly into global force vector
      for k=1:n
         locarray(2*k-1:2*k)=obj.NodeDict(table(i,k)).DofArray(1:2);
         % using doflist in the node object to construct a locarray for
         % assembly
      end
      FFG(locarray)=FFG(locarray)+fe;
end
obj.RHS=FFG;
end

