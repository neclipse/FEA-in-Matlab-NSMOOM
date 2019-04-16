classdef Elem_2d_EP < handle
    properties
        Ind
        Type                    % Element type reheritated from the class Domain
        MatType
        NodList
        NodDict
        X
        Y
        Area
        NoNodes                 % Number of total nodes in this element
        IntLoadVec              % Element internal load vector
		ExtLoadVec              % Element external load vector
        StifMatrix              % K matrix for the mechanic equllibrium equation	
        LocarrayU
        LocarrayP
        ItrDisp	
        GaussPntDictM           % object array of class GaussPnt for mechanic module
        EPFlag=0;               % '1' means elatoplastic, '0' means pure elastic
    end
    
    methods
        function obj=Elem_2d_EP(index,elemtype,mattype,nodlist,noddict)
            if nargin>0
               obj.Ind=index;
               obj.Type=elemtype;
               obj.MatType=mattype;
               obj.NodList=nodlist; 
               % nodlist is ordered in counterclockwise by vertices first and side nodes last
               obj.NodDict=noddict;  
               obj.X=[noddict.X]';
               obj.Y=[noddict.Y]';
               obj.NoNodes=length(noddict);
               obj.IntLoadVec=zeros(obj.NoNodes*2,1);
               obj.ExtLoadVec=zeros(obj.NoNodes*2,1);
               obj.crtgpd(2);
               obj.calarea;
            end
        end
        crtgpd(obj,varargin);   % create the gaussian point dictionary for Elasto-Plastic model
        crtstif(obj);           % create element stiffness matrix, call matct
        givelocarray(obj,varargin);
		ifstd(obj);             % compute internal force vectors; call listra and matsu
        assemble(obj,Gstif);
        calarea(obj);
    end
    
end