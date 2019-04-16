function crtRHS_v3( obj )
%CRTRHS_V3 Create the right hand side of the linear system
%   This function include integration and assembly
%   This new version is compatible with new BCTable_load 
global inistress;
FFG=zeros(obj.Drow,1);
INI=zeros(obj.Drow,1);
nonodes=obj.ElemDict(1).NoNodes;                    % nonodes: the number of nodes invloved in the element stiffness matrix
[~,Nline_xi]=lineshape(nonodes,1);
n=length(Nline_xi);                                 % An indirect way to decide the number of nodes along a side of element
if nonodes==3 || nonodes==6                         % For triangular elements
    [xx,ww]=GaussQuad(1,1);                         % calculating gauss points along a line from 0 to 1
elseif nonodes==4 || nonodes==8                     % For rectangular elements
    [xx,ww]=GaussQuad(1);                           % calculating gauss points along a line from -1 to 1
end
%%-- Calculate the initial load vector
    wholetable=[obj.BCTables;obj.BCTablet];         % All boundary sides with loads  
for istress=1:size(wholetable,1)
    table=wholetable{istress};
    for i=1:size(table,1)
      fe=zeros(2*n,1);
      locarray=zeros(2*n,1);
      X=[obj.NodeDict(table(i,1:n)).X];             % X is a row vector
      % X is the x coordinates list of the nodes along the boundary side
      Y=[obj.NodeDict(table(i,1:n)).Y]; 
      % loop over gaussian points
      for j=1:length(xx)
         xi=xx(j);
         [Nline,Nline_xi]=lineshape(nonodes,xi);
         x_xi=Nline_xi*X';
         y_xi=Nline_xi*Y';
         normal=[y_xi,0,-x_xi,0;0,-x_xi,y_xi,0];    % THIS FORMULA IS DEBATABLE for Triangle Elements
         fet=Nline'*normal*inistress;               % THIS FORMULA IS DEBATABLE for Triangle Elements
         fe=fe+ww(j)*fet;
      end
      %% Assembly into global force vector
      for k=1:n
         locarray(2*k-1:2*k)=obj.NodeDict(table(i,k)).DofArray(1:2);
         % using doflist in the node object to construct a locarray for
         % assembly
      end
      INI(locarray)=INI(locarray)+fe;
    end
end
%%-- Calculate the current load vector using BCTable_stress
stable=obj.BCTables;                                 % BCTable_load: node indices and side-wise stress tensor
for istress=1:size(stable,1)
    table=stable{istress};
    for i=1:size(table,1)
      fe=zeros(2*n,1);
      locarray=zeros(2*n,1);
      X=[obj.NodeDict(table(i,1:n)).X];             % X is a row vector
      % X is the x coordinates list of the nodes along the boundary side
      Y=[obj.NodeDict(table(i,1:n)).Y]; 
      loads=table(i,(n+1):end);
      % loop over gaussian points
      for j=1:length(xx)
         xi=xx(j);
         [Nline,Nline_xi]=lineshape(nonodes,xi);
         x_xi=Nline_xi*X';
         y_xi=Nline_xi*Y';
         normal=[y_xi,0,-x_xi,0;0,-x_xi,y_xi,0];    % THIS FORMULA IS DEBATABLE for Triangle Elements
         fet=Nline'*normal*loads';                   % THIS FORMULA IS DEBATABLE for Triangle Elements
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
end
%%-- Calculate the current load vector using BCTable_traction
ttable=obj.BCTablet;                                 % BCTable_traction: node indices and side-wise traction                              % BCTable_load: node indices and side-wise stress tensor
for itraction=1:size(ttable,1)
    table=ttable{itraction};
    for i=1:size(table,1)
      fe=zeros(2*n,1);
      locarray=zeros(2*n,1);
      X=[obj.NodeDict(table(i,1:n)).X];             % X is a row vector
      % X is the x coordinates list of the nodes along the boundary side
      Y=[obj.NodeDict(table(i,1:n)).Y]; 
      loads=table(i,(n+1):end);
      % loop over gaussian points
      for j=1:length(xx)
         xi=xx(j);
         [Nline,Nline_xi]=lineshape(nonodes,xi);
         x_xi=Nline_xi*X';
         y_xi=Nline_xi*Y';
         ds=sqrt(x_xi^2+y_xi^2);
         fett=loads'*ds;
         fet=Nline'*fett;                       % THIS FORMULA IS DEBATABLE for Triangle Elements
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
end
obj.RHS=FFG-INI;                                    % RHS is the change of load vector
end

