classdef GaussPnt_LE < FEPack.GaussPnt
  
   methods
       function obj=GaussPnt_LE(xi,eta,h,nnodes)
           if nargin==0
               super_args={};
           elseif nargin==4
               super_args={xi,eta,h,nnodes};
           else
               error('Wrong number of inputs')
           end
           obj=obj@FEPack.GaussPnt(super_args{:});
       end
       matsu(obj);
       matct(obj);

   end
    
end