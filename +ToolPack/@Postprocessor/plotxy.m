function h= plotxy( obj,variable,indices,varargin )
%PLOTXY X-Y Plot method of Postprocessor
%   To plot variable versus distant at nodes/element(one point per element) defined by the indices 
nodal={'UX','UY'};
gaussian={'ESnG','PSnG','EPBar','SG'};
inc=num2str(obj.IInc);
if ismember(variable,nodal)
    X=obj.XN(indices);
    Y=obj.YN(indices);
    xo=X(1); yo=Y(1);                           % Define the first node as the origin of the node path
    S=sqrt((X-xo).^2+(Y-yo).^2);                % Distance along the path measured from the origin
    var=get(obj,variable);
    var=var(indices);
    titlename=['X-Y plot of ',variable,' at nodes after ',inc,' of full loads' ];
    figure('Name',titlename,'NumberTitle','off');
    h=plot(S,var,'k');
    h.Marker='*';
    title(titlename)
    xlabel('Distance along the path measured from the first node')
    ylabel(variable)
    
elseif ismember(variable,gaussian)
    X=obj.XG(indices);
    Y=obj.YG(indices);
    xo=X(1); yo=Y(1);                           % Define the first node as the origin of the node path
    S=sqrt((X-xo).^2+(Y-yo).^2);                % Distance along the path measured from the origin
    var=get(obj,variable);
    var=var(indices,:);
    if ~isempty(varargin)
        var=var(:,varargin{1});                 % To be compatible with EPBar
        component=num2str(varargin{1});
        titlename=['X-Y plot of ', variable,component,' at Gaussian points after ',inc,' of full loads' ];
    else
        titlename=['X-Y plot of ', variable,' at Gaussian points after ',inc,' of full loads'];
    end   
    figure('Name',titlename,'NumberTitle','off');
    h=plot(S,var,'k');
    h.Marker='o';
    title(titlename)
    xlabel('Distance along the path measured from the first node')
    ylabel(variable)
end    

end

