function h=plotcontour( obj, variable, meshstructure,varargin )
%PLOTCONTOUR Method of Postprocessor class
nodal={'UX','UY'};
gaussian={'ESnG','PSnG','EPBar','SG'};
ncontour=10;                                  % default number of contour lines
if nargin==4
    component=varargin{1}; 
elseif nargin==5
    component=varargin{1}; 
    ncontour=varargin{2};                    % specify the number of contour lines
end
inc=num2str(obj.Inc);
if ismember(variable,nodal)
    %reshape the vectors to be compatible with the requirement of the built-in 'contourf'
    X=transpose(reshape(obj.XN,meshstructure));
    Y=transpose(reshape(obj.YN,meshstructure));
    var=get(obj,variable);
    var=transpose(reshape(var,meshstructure));
    titlename=['Countour plot of ',variable,' at nodes after ',inc,' of full loads'];
    figure('Name',titlename,'NumberTitle','off');
    h=contourf(X,Y,var,ncontour); 
    colormap (jet)
    colorbar
    title(titlename);
    xlabel('x');
    ylabel('y');
    
elseif ismember(variable,gaussian)
    X=transpose(reshape(obj.XG,meshstructure));
    Y=transpose(reshape(obj.YG,meshstructure));
    var=get(obj,variable);
    if nargin>3
        var=var(:,component);                 % To be compatible with EPBar
        component=num2str(component);
        titlename=['Countour plot of the ', variable,component,' at Gaussian points after ',inc,' of full loads'];
    else
        titlename=['Countour plot of the ', variable,' at Gaussian points after ',inc,' of full loads'];
    end   
    var=transpose(reshape(var,meshstructure));
    figure('Name',titlename,'NumberTitle','off');
    h=contourf(X,Y,var,ncontour);
    colormap (jet)
    colorbar
    title(titlename);
    xlabel('x');
    ylabel('y');
end    
end

