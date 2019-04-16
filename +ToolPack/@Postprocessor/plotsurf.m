function h=plotsurf( obj, variable, meshstructure,varargin )
%PLOTCONTOUR Method of Postprocessor class
nodal={'UX','UY'};
gaussian={'ESnG','PSnG','EPBar','SG'};
inc=num2str(obj.Inc);
if ismember(variable,nodal)
    %reshape the vectors to be compatible with the requirement of the built-in 'surf'
    X=transpose(reshape(obj.XN,meshstructure));
    Y=transpose(reshape(obj.YN,meshstructure));
    var=get(obj,variable);
    var=transpose(reshape(var,meshstructure));
    titlename=['Surface plot of ',variable,' at nodes after ',inc,' of full loads'];
    figure('Name',titlename,'NumberTitle','off');
    h=surf(X,Y,var); 
    colormap (jet)
    colorbar
    title(titlename)
    xlabel('x')
    ylabel('y')
    view(0,90)
    
elseif ismember(variable,gaussian)
    X=transpose(reshape(obj.XG,meshstructure));
    Y=transpose(reshape(obj.YG,meshstructure));
    var=get(obj,variable);
    if ~isempty(varargin)
        var=var(:,varargin{1});                 % To be compatible with EPBar
        component=num2str(varargin{1});
        titlename=['Surface plot of the ', variable,component,' at Gaussian points after ',inc,' of full loads'];
    else
        titlename=['Surface plot of the ', variable,' at Gaussian points after ',inc,' of full loads'];
    end   
    var=transpose(reshape(var,meshstructure));
    figure('Name',titlename,'NumberTitle','off');
    h=surf(X,Y,var);
    colormap (jet)
    colorbar
    title(titlename);
    xlabel('x');
    ylabel('y');
    view(0,90);
end    
end

