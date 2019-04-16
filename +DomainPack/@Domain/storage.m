function storage( obj, iinc, inc, varargin )
%STORAGE Method of Domain class, to store important results for
%postprocessing.
%   It runs after every converged load increment in the 'running' method. The method will store
%   results into an instance of 'Postprocessor'.
% Prepare an object of postprocessor class
global inistress
if nargin==3
    ind=iinc;                                               % index of the post in the postprocessor array is the same as iinc
elseif nargin==4
    ind=varargin{1};                                        % index of the post in the postprocessor array is different from iinc
end
noelem=length(obj.ElemDict);
% gaussn=length(obj.ElemDict(1).GaussPntDictM);             % number of gaussian points within one element
gausscol=1;                                                 % number of gaussian points to represent one element
post=ToolPack.Postprocessor();
post.EPArea=obj.LinSysCrt.EPArea;
%% Store the nodal results
post.IInc=iinc;
post.Inc=inc;
post.XN=obj.Preprocess.Mesher.VX;
post.YN=obj.Preprocess.Mesher.VY;
post.UX=obj.LinSysCrt.TotDispO(1:2:end-1);
post.UY=obj.LinSysCrt.TotDispO(2:2:end);
%% Store the results on integration points
% --Loop over element dictionary
indgauss=0;
for ielem=1:noelem
    elem=obj.ElemDict(ielem);
   % -- Loop over gaussian points dictionary
       for igauss=1:gausscol
           indgauss=indgauss+1;
           gauss=elem.GaussPntDictM(igauss);
           post.XG(indgauss)=gauss.X;
           post.YG(indgauss)=gauss.Y;
           post.ESnG(indgauss,:)=gauss.ElaStnO';
           post.PSnG(indgauss,:)=gauss.PlaStnO';
           post.EPBar(indgauss,:)=gauss.EPBarO';
           post.SG(indgauss,:)=gauss.StresscO'+inistress';
       end
end
obj.Postprocess(ind)=post;
end

