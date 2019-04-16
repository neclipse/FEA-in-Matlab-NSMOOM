function ifstd( obj )
%     global inistress;
    itrdisp=obj.ItrDisp; % elemental displacement vector
    numgauss=length(obj.GaussPntDictM);
    load=zeros(size(itrdisp));
    for i=1:numgauss
    % calculate the contribution of one gaussian point to the element strain
        obj.GaussPntDictM(i).listra(itrdisp);
		obj.GaussPntDictM(i).matsu;
        % The fouth component dosen't make contribution to load vector in plane problem
        stressc=obj.GaussPntDictM(i).Stressc;  % RELATIVE STRESS to the initial stress
%         stressc=inistress;                    % AN INTERESTING POINT: THE
%         INTERAL LOAD VECTOR CONVERGES WITH EXTERNAL LOAD VECTOR WHEN THE
%         PRESCIBED INITIAL STRESS IS DIVIDED BY 2
        B=obj.GaussPntDictM(i).Bmat;
        dJ=obj.GaussPntDictM(i).DetJ; 
        H=obj.GaussPntDictM(i).H; 
		gaussload=H*dJ*B'*stressc;
        if obj.NoNodes==3 || obj.NoNodes==6
           gaussload=gaussload/2;              % The formula of area integral over a triangle has this coefficient 1/2.
        end
		load=load+gaussload;
    end
	obj.IntLoadVec=load;  % element relative internal force vector for current accumulative load increment
end

