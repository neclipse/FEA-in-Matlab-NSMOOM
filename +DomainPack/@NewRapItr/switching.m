function switching(obj, mode)
%SWITCHING Method of NewRapItr Class 
%   Switching between current value and last converged value 
%   according to the switching modes
%-- Mode "1": Store current values of some parameters as the last
%converged values. The parameters include Internal load vector, LHS.
%Call GaussPnt.Switching(1) for all gauss points.
%This situation occurs when the convergence criterion is met, at the end 
%of the iterations for the current load increment.
%-- Mode "2": Reset the current values of some parameters to last converged value.
%Internal load vector to the last converged value;
%LHS to the last converged value;
%Call GaussPnt.Switching(2) for all gauss points.
%New External load vector and new RHS; 
%IItr=0 and Convergence flag=0. This scenario happens when the returning is
%moving to the next load increment or increment cutting is activated.

% Switching values of parameters of gaussian points class
nelem=length(obj.LinSysCrt.ElemDict);
ngauss=length(obj.LinSysCrt.ElemDict(1).GaussPntDictM);
for ielem=1:nelem
   for igauss=1:ngauss
       obj.LinSysCrt.ElemDict(ielem).GaussPntDictM(igauss).switching(mode);
   end
end
% Switching values of parameters of NewRapItr class
if mode==1
    obj.IntLoadVecO=obj.IntLoadVec;
    obj.LinSysCrt.LHSO=obj.LinSysCrt.LHS;
    obj.LinSysCrt.TotDispO=obj.LinSysCrt.TotDisp;
elseif mode==2
    % Reset LHS by LHSO if not the first load increment
    if obj.IInc~=1
        obj.LinSysCrt.LHS=obj.LinSysCrt.LHSO;
    end
    obj.LinSysCrt.TotDisp=obj.LinSysCrt.TotDispO;
    obj.IntLoadVec=obj.IntLoadVecO;
    if obj.IncType==1
        obj.ExtLoadVec=obj.FullExtLoad*obj.Increments(obj.IInc);
    elseif obj.IncType==2
        obj.LinSysCrt.Predisp=obj.LinSysCrt.TotPredisp*obj.Increments(obj.IInc);
        obj.LinSysCrt.appbound_v2;          % Update the load by incremental displacement
        obj.ExtLoadVec=obj.LinSysCrt.RHS;   % Update accumulative external load vector 
    end
    obj.LinSysCrt.RHS=obj.ResLoadVec;
    obj.ConvFlag=0;
    obj.DivFlag=0;
    obj.IItr=0;
end
end
