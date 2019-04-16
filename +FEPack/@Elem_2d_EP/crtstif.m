function crtstif( obj )
%CRTST method of elem_2d_EP to calculate the stiffness matrix using gauss
%point class
%   This function is slightly different from the calstifmatrix in class
%   elem_2d due to the new member GaussPntDict in the elem_2d_EP
%   Each gauss point object calculates the consistent tangent operator,D
%   matrix. This function is more like a assembler.
    nnodes=obj.NoNodes;
    ndof=2;
    X=obj.X(1:nnodes); 
    Y=obj.Y(1:nnodes);
    r=ndof*nnodes;
    melem=zeros(r,r); % Preallocate a zero matrix for the stiffness matrix;
    numgauss=length(obj.GaussPntDictM);
    for igauss=1:numgauss
        % calculate the tangent operator consistent with the last converged
        % stress state
        obj.GaussPntDictM(igauss).matct;
        D=obj.GaussPntDictM(igauss).Tangent;
        B=obj.GaussPntDictM(igauss).Bmat;
        dJ=obj.GaussPntDictM(igauss).DetJ;
        H=obj.GaussPntDictM(igauss).H;
        if isempty(B)||isempty(dJ)    
           obj.prestif(X,Y);
        end
        if obj.NoNodes==3 || obj.NoNodes==6
           melem=melem+0.5*H*dJ*B'*D*B;            % The formula of area integral over a triangle has this coefficient 1/2.
        else
           melem=melem+H*dJ*B'*D*B;
        end
        % Assist in telling if the calculation for this element is plastic
        if obj.GaussPntDictM(igauss).EPFlag==1
           obj.EPFlag=1; 
        end
    end
    obj.StifMatrix=melem;

end

