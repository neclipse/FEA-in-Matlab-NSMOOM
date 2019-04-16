function  upconf( obj )
%UNPCONF method of linear system creater
%   update configuration: incremental displacements and total accumulated displacements
% nnode=length(obj.NodeDict);

nelem=length(obj.ElemDict);
% for inode=1:nnode
%    Disparray=obj.NodeDict(inode).DofArray(1:2);     % The potential third index is for the global location of pressure dof
%    obj.NodeDict(inode).ItrDispList=obj.Unknowns(Disparray);
%    obj.NodeDict(inode).IncDispList=obj.NodeDict(inode).IncDispList+obj.NodeDict(inode).ItrDispList;
%    obj.NodeDict(inode).TotDispList=obj.NodeDict(inode).TotDispList+obj.NodeDict(inode).ItrDispList;
% end
for ielem=1:nelem
    DispVec=obj.ElemDict(ielem).LocarrayU;
    obj.ElemDict(ielem).ItrDisp=obj.Unknowns(DispVec); 
end

end

