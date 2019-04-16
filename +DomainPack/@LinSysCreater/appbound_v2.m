function appbound_v2( obj )
%APPBOUND_v2 This function applies essential boundary condition to the
%linear system.
% This version can allow incremental non-zero displacement boundary
% condition.
%% Apply essential boundary conditon from BCTable_disp                                % Locarry for dofs on pseudo boundaries
if ~isempty(obj.BCTabled)
    Pseudobound=[];
    for idisp=1:length(obj.Predisp)                 % Go through all displacement conditions
       disptable=obj.BCTabled{idisp};
       nodelist=disptable(1,:);
       idof=disptable(2,1);
       locarray=[obj.NodeDict(nodelist).DofArray];  % Retrieve the boundary condition, 1-x_disp; 2-y-disp.
       locarray=locarray(idof:2:end);               % The last element of locarray is not extracted when idof=1;
       %- Approximation method to assign boundary condition
       index = sub2ind(size(obj.LHS),locarray ,locarray );
       obj.LHS(index)=1E29;
       obj.RHS(locarray)= 1E29*obj.Predisp(idisp);
       %- O-1 Method to assign boundary condtion
    %     obj.LHS(locarray,:)=0;
    %     obj.LHS(:,locarray)=0;
    %     obj.RHS(locarray)=0;
    %     index = sub2ind(size(obj.LHS),locarray ,locarray );
    %     obj.LHS(index)=1;
      Pseudobound=[Pseudobound,locarray];                           % Locarry for dofs on pseudo boundaries
      save('Pseudobound.mat', 'Pseudobound');                       % EXTERNAL BOUNDARY IS NOT PSEUDOBOUND
    end
        % Pseudobound is only ok when there are special nodes in the BCTable_node
end
%% Apply essential boundary conditon from BCTable_node (sparse nodes)
if ~isempty(obj.BCTablen)
    for inode=1:size(obj.BCTablen,1)
       idof=obj.BCTablen(inode,1);
       nodelist=obj.BCTablen(inode,2);
       locarrayn=obj.NodeDict(nodelist).DofArray(idof);
       index = sub2ind(size(obj.LHS),locarrayn ,locarrayn );
       obj.LHS(index)=1E29;
       obj.RHS(locarrayn)= 1E29*obj.BCTablen(inode,5);
    end
end

end

