function  crtgpd( obj, varargin )
%CRTGPD  create the gaussian point dictionary, called by the constructor of
%Elem_2d_EP
% Inputs explanation
% obj: the elem_2d object itself
% p:   the order of the Gaussian quadrature (p<=12)
global inistress Delastic;
    p=2;     nnodes=obj.NoNodes;
%% Specify the inputs
    if nargin==2
        p=varargin{1}; % the third input is the order of the integreted polynomial
    end
%% Specify the required number of gaussian points
    if nnodes==3||nnodes==6 % Triangular elements
        % IMPORTANT ERROR IF WRITTEN AS NNODES==3||6
        gauss=triGaussPoints(p); % This function gives gauss integration points and their weights;
    elseif nnodes==4||nnodes==8 % Rectangular elements
        [xx,ww]=GaussQuad(p);
        s=length(xx);
        gauss=zeros(s^2,3);
        ind=1;
        for ixi=1:s
            for ieta=1:s
                gauss(ind,:)=[xx(ixi),xx(ieta),ww(ixi)*ww(ieta)];
                ind=ind+1;
            end
        end
    end
    numgauss=size(gauss,1); % number of gauss points
%% Create proper gaussian point dictionary corresponding to material type
    if obj.MatType==1
        gaussdictm(1:numgauss)=FEPack.GaussPnt_LE(); %generate an void object array
    for igauss=1:numgauss
        gaussdictm(igauss)=FEPack.GaussPnt_LE(gauss(igauss,1),gauss(igauss,2),gauss(igauss,3),nnodes);
        gaussdictm(igauss).preparing(obj.X,obj.Y);
        gaussdictm(igauss).initial(inistress, Delastic);
    end
    elseif obj.MatType==2
        gaussdictm(1:numgauss)=FEPack.GaussPnt_DP(); %generate an void object array
        for igauss=1:numgauss
            gaussdictm(igauss)=FEPack.GaussPnt_DP(gauss(igauss,1),gauss(igauss,2),gauss(igauss,3),nnodes);
            gaussdictm(igauss).preparing(obj.X,obj.Y);
            gaussdictm(igauss).initial(inistress, Delastic);
        end
    elseif obj.MatType==3
        gaussdictm(1:numgauss)=FEPack.GaussPnt_DPC(); %generate an void object array
        for igauss=1:numgauss
            gaussdictm(igauss)=FEPack.GaussPnt_DPC(gauss(igauss,1),gauss(igauss,2),gauss(igauss,3),nnodes);
            gaussdictm(igauss).preparing(obj.X,obj.Y);
            gaussdictm(igauss).initial(inistress, Delastic);
        end
    end
    obj.GaussPntDictM=gaussdictm;
end

