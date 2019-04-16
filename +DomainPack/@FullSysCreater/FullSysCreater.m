classdef FullSysCreater < DomainPack.LinSysCreater
   methods
      function obj=FullSysCreater(drow,dcol,elemtype,mattype,elemdict,nodedict,predisp,bctables,bctablet,bctablen,bctabled)
%            global elementdictionary;
           obj@DomainPack.LinSysCreater(drow,dcol,elemtype,mattype,elemdict,nodedict,predisp,bctables,bctablet,bctablen,bctabled);
      end
      function crtLHS(obj)
            Gstif=zeros(obj.Drow,obj.Dcol);
            for ielem=1:length(obj.ElemDict)
        %                 fprintf('Assembling the %d element\n',ielem);
                obj.ElemDict(ielem).crtstif;
                obj.ElemDict(ielem).givelocarray; 
                Gstif=obj.ElemDict(ielem).assemble(Gstif);
            end
            obj.LHS=Gstif;
      end
%         function solve(obj)
%             obj.Unknowns=obj.LHS\obj.RHS;
%         end
   end
end
