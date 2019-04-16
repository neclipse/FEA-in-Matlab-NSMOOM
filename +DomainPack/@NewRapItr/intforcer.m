function intforcer( obj )
%INTFORCER Method of Returner class
%   Loop over all elements to calculate and assemble the global interal
%   load vector, this method will call elemental method--ifstd
edict=obj.LinSysCrt.ElemDict;
% IMPORTANT ERROR: LOADVEC SHOULD BE RESET TO ZERO FOR EVERY ITERATION SINCE 
% THE ELEMENT INTLOADVEC IS ALREADY ACCUMULATED LOAD, INSTEAD OF LOAD CHANGE
loadvec=zeros(obj.Dim,1);
for ielem=1:length(edict)
    edict(ielem).ifstd;
    array=edict(ielem).LocarrayU;
    loadvec(array')=loadvec(array')+edict(ielem).IntLoadVec;
end
obj.IntLoadVec=loadvec;
end
