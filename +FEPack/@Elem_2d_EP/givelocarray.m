function  [locarrayu,locarrayp]=givelocarray(obj,varargin)
%GIVELOCARRAY Calculate the global index of DOf
if nargin==1 % all nodes are involved
    nnodes=obj.NoNodes; 
elseif nargin==2 % only selected nodes are involved
    nnodes=varargin{1};
end
ndofu=2;ndofp=1;
locarrayu=zeros(1,ndofu*nnodes);% location array of DOFs of displacement
locarrayp=zeros(1,ndofp*nnodes);% location array of DOFs of pressure
for inod=1:nnodes
    locarrayu(ndofu*inod-1:ndofu*inod)=obj.NodDict(inod).DofArray(1:2);
    if obj.NodDict(inod).NoDofs==3
        locarrayp(inod)=obj.NodDict(inod).DofArray(3);
    end
end
obj.LocarrayU=locarrayu;
obj.LocarrayP=locarrayp;
end


