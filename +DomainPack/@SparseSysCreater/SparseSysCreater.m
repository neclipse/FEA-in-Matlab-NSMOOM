classdef SparseSysCreater < DomainPack.LinSysCreater
   methods
      function obj=SparseSysCreater(drow,dcol,elemtype,mattype,elemdict,nodedict,predisp,bctables,bctablet,bctablen,bctabled)
%            global elementdictionary;
           obj@DomainPack.LinSysCreater(drow,dcol,elemtype,mattype,elemdict,nodedict,predisp,bctables,bctablet,bctablen,bctabled);
      end
      function crtLHS(obj)
          obj.ElemDict(1).crtstif; % To determin the size of the stiffness matrix;
          % IMPORTANT ERROR: WITHOUT THIS CALCULATION, THE FOLLOWING I J
          % VALUE WOULD BE EMPTY.
            [dr,dc]=size(obj.ElemDict(1).StifMatrix);
            ntriplets=length(obj.ElemDict)*dr*dc;
            I=zeros(ntriplets,1);
            J=I;Value=I;
            ntriplets=0;
            obj.EPArea=0;
            for ielem=1:length(obj.ElemDict)
        %                 fprintf('Assembling the %d element\n',ielem);
                obj.ElemDict(ielem).crtstif;
                obj.ElemDict(ielem).givelocarray; 
                row=obj.ElemDict(ielem).LocarrayU;
                col=row; % square matrix
                for irow=1:dr
                    for icol=1:dc
                        ntriplets = ntriplets + 1 ;
                        I(ntriplets) = row(irow); % row index in global stiffness matrix given by location array
                        J(ntriplets) = col(icol);
                        Value(ntriplets) = obj.ElemDict(ielem).StifMatrix(irow,icol) ;
                    end
                end
				if obj.ElemDict(1).MatType~=1
                % Assist in measuring the extent of plastic yielding
                    if obj.ElemDict(ielem).EPFlag
                        obj.EPArea=obj.EPArea+obj.ElemDict(ielem).Area;
                    end
				end
            end
            obj.LHS=sparse(I,J,Value,obj.Drow,obj.Dcol);
      end
%         function solve(obj)
%             obj.Unknowns=obj.LHS\obj.RHS;
%         end
   end
end
