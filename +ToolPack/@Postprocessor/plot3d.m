function  h=plot3d( obj, variable, varargin)
%PLOT3D 3D line Plot method of Postprocessor
nodal={'UX','UY'};
gaussian={'ESnG','PSnG','EPBar','SG'};
inc=num2str(obj.IInc);
if ismember(variable,nodal)
    X=obj.XN;
    Y=obj.YN;
    var=get(obj,variable);
    titlename=['3D plot of ',variable,' at nodes after ',inc,' Increment' ];
    figure('Name',titlename,'NumberTitle','off');
    h=plot3(X,Y,var,'k');
    h.LineStyle='none';
    h.Marker='.';
    title(titlename)
    xlabel('x')
    ylabel('y')
    
elseif ismember(variable,gaussian)
    X=obj.XG;
    Y=obj.YG;
    var=get(obj,variable);
    if ~isempty(varargin)
        var=var(:,varargin{1});                 % To be compatible with EPBar
        component=num2str(varargin{1});
        titlename=['3D plot of ', variable,component,' at Gaussian points after ',inc,' of full loads' ];
    else
        titlename=['3D plot of ', variable,' at Gaussian points ',inc,' of full loads'];
    end   
    figure('Name',titlename,'NumberTitle','off');
    h=plot3(X,Y,var,'b');
    h.LineStyle='none';
    h.Marker='.';
    title(titlename)
    xlabel('x')
    ylabel('y')
end    
end





