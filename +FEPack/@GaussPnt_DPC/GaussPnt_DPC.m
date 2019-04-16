classdef GaussPnt_DPC < FEPack.GaussPnt
   properties
       ApexFlag    % '1' means returning to the apex, while'0' means returning to the smooth cone
       ApexFlagO   % Last converged value
   end
   
   methods
       function obj=GaussPnt_DPC(xi,eta,h,nnodes)
           if nargin==0
               super_args={};
           elseif nargin==4
               super_args={xi,eta,h,nnodes};
           else
               error('Wrong number of inputs')
           end
           obj=obj@FEPack.GaussPnt(super_args{:});
           obj.ApexFlag=0;
           obj.ApexFlagO=0;
       end
       matsu(obj,matprop);
       matct(obj,matprop);
       function switching(obj,mode)
          switching@FEPack.GaussPnt(obj,mode);
          if mode==1
              obj.ApexFlagO=obj.ApexFlag;
          elseif mode==2
              obj.ApexFlag=obj.ApexFlagO;
          end
       end
   end
    
end