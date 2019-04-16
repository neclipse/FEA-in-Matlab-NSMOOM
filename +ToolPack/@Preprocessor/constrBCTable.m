function constrBCTable(obj)
%% Construct the BCTable_line first, this is the basis of boundary condition table
%RHS are buided directly based on BCTable_line
%BCTable_disp is a combination of BCTable_line and BCTable_node. It is builded for appbound.m
%Special nodes(which have been already constrained by boundary loads)
%should be avoided in the BCTable_disp.
tol=1E-5;
maxiter=3;
iiter=0;
nln=size(obj.BoundEdge,2); % number of nodes on a side of an element
while size(obj.BCTable_line,1)~=size(obj.BoundEdge,1)
    obj.BCTable_line=[];   % set a void BCTable_line
    for i=1:obj.Nobound
        fd=obj.Disthandle{i,1};
        fd_num=i;
        BCcode=obj.BCmat_line(i,:); 
        obj.BCTable_line=CorrectBCTable_v7(obj.BoundEdge,obj.Mesher.VX,obj.Mesher.VY,obj.BCTable_line,fd,fd_num,BCcode,tol);
        % fd: handle of the distance function of a boundary 
        % BCcode: integer vertice representing the boundary condition
        % of all Dofs. For example, [1,1,1] means constant displacement boundary
        % condition applies to the first two Dofs and constant load
        % condition applies to the third Dof.
        % tol: the numerical tolerance of distance to locate the boundeges
    end
    if size(obj.BCTable_line,1)>size(obj.BoundEdge,1)
        tol=tol*10;
        elseif size(obj.BCTable_line,1)<size(obj.BoundEdge,1)
        tol=tol/10;
    end
    iiter=iiter+1;
    if iiter>maxiter
       error('BCTable_line is built with error.') 
    end
end
%% Construct the BCTable_node accordingly
if ~isempty(obj.BCTable_node)
    for i=1:size(obj.BCTable_node,1)
        % The specified nodes are given coordinates or index. Index for 
        % those with coordinates is preassigned as zero, and should be
        % retrieved through the "itemize" function
        if obj.BCTable_node(i,2)==0
           id=obj.Mesher.itemize(obj.BCTable_node(i,3),obj.BCTable_node(i,4));
           obj.BCTable_node(i,2)=id;
        end
    end
    idspecial=logical(obj.BCTable_node(:,end)==0);
    idnode=obj.BCTable_node(idspecial,2);               % Index of all special(contradictory) nodes
    idrem=logical(obj.BCTable_node(:,1)~=0);
    obj.BCTable_node=obj.BCTable_node(idrem,:);         % BCTable_node with specific displacement
    % Format of BCTable_node:
    % 1st column: The type of the dof, 1- xdisp, 2-ydisp
    % 2nd column: The global index of the node
    % 3rd and 4th: The coordinates of the node
    % 5th column: The prescribed displacement
else
    idnode=[];
end
%% Construct BCTable_disp                                % Empty matrix to avoid redundancy
[ir1,ic1]= find(obj.BCmat_line==1);
obj.BCTable_disp=cell(size(ir1,1),1);
for idisp=1:length(ir1)
   indbd=logical(obj.BCTable_line(:,1)==ir1(idisp)); % Find all edges on this boundary
   bctemp=obj.BCTable_line(indbd,:);             
   bctemp=bctemp(:,2:nln+1);
   bctemp=unique(bctemp);
   bctemp=bctemp';
   if ~isempty(idnode)                              % If any special nodes
       for idn=1:length(idnode)                     % Delete speical nodes one by one
          bctemp=bctemp(bctemp~=idnode(idn)); 
       end
   end
   idof = repmat(ic1(idisp),length(bctemp),1);       % boundary condition, 1-x_disp; 2-y-disp.
   bctemp=[bctemp;idof'];
   obj.BCTable_disp{idisp}=bctemp;
end

%% Construct load boundary condition table
[ir2,~]= find(obj.BCmat_line==2); 
[ir3,~]= find(obj.BCmat_line==3);
obj.BCTable_stress=cell(size(ir2,1),1);
obj.BCTable_traction=cell(size(ir3,1),1);
noloads=size(obj.CurLoads,1);
iloads=0;
    %-- Build BCTable_stress for boundaries with uniform spreading load in
    % cartesian coordinate system
    for icart=1:length(ir2)
        iloads=iloads+1;                                    
        indbd=logical(obj.BCTable_line(:,1)==ir2(icart)); % Find all edges on this boundary
        bctemp=obj.BCTable_line(indbd,:);
        bctemp=bctemp(:,2:nln+1);
        curloads=obj.CurLoads{iloads};
        Curloads=repmat(curloads,size(bctemp,1),1);
        bctemp=[bctemp,Curloads];
        obj.BCTable_stress{icart}=bctemp;
    end

    %-- Build BCTable_traction for boundaries with varing spreading load in
    % cartesian coordinate system
    % However, the method is not valid yet.
    for icylind=1:length(ir3)
        iloads=iloads+1;                                    
        indbd=logical(obj.BCTable_line(:,1)==ir3(icylind));   % Find all edges on this boundary
        bctemp=obj.BCTable_line(indbd,:);
        bctemp=bctemp(:,2:nln+1);
        curloads=obj.CurLoads{iloads};
        if nln==2
            x1=obj.Mesher.p(bctemp(:,1),1);                % x-coord of the first node
            x2=obj.Mesher.p(bctemp(:,2),1);                % x-coord of the second node
            X=(x1+x2)/2;
            y1=obj.Mesher.p(bctemp(:,1),2);                % y-coord of the first node
            y2=obj.Mesher.p(bctemp(:,2),2);                % y-coord of the second node
            Y=(y1+y2)/2;
        elseif nln==3
            X=obj.Mesher.p(bctemp(:,2),1);
            Y=obj.Mesher.p(bctemp(:,2),2);
        end
        % Transform stress form cylindrical coordinate system to cartesian coordinate system
        Curloads=loadr2x(curloads,X,Y); 
        bctemp=[bctemp,Curloads];
        obj.BCTable_traction{icylind}=bctemp;
    end
    if iloads~=noloads
       error('Boundary loads condition table is built with error.'); 
    end
end




















