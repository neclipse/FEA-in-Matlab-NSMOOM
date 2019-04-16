function assignmesh(obj) 
   Mesher=obj.Preprocess.Mesher;
% NodeDict
   totndof=obj.NoDofs;
   nodedict(1:Mesher.Totnodes)=FEPack.Node();
   for inod=1:Mesher.Totnodes
       x=Mesher.VX(inod);
       y=Mesher.VY(inod);
       type=Mesher.VT(inod);
       nodedict(inod)=FEPack.Node(inod,type,x,y); 
       totndof=nodedict(inod).givedofarray(totndof);
   end
   obj.NodeDict=nodedict;
   obj.NoDofs=totndof;
% ElemDict   
   elemdictionary(1:Mesher.Totelem)=FEPack.Elem_2d_EP(); % element class should have default constructor
   for ielem=1:Mesher.Totelem
       elemdictionary(ielem)=FEPack.Elem_2d_EP(ielem,obj.ElemType,obj.MatType, Mesher.EToV(ielem,:), nodedict(Mesher.EToV(ielem,:)));  
   end
   obj.ElemDict=elemdictionary; %IMPORTANT: IT IS NOT ALLOWED TO CREATE AN OBJECT ARRAY AND ASSIGN IT TO A PROPERTY OF ANOTHER OBJECT
end
