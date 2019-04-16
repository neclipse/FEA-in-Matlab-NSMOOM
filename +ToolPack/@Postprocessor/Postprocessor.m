classdef Postprocessor < matlab.mixin.SetGet
properties
    IInc                 % The value of increment when the postprocessor is created
    Inc
    XN                  % X-coordinates of all nodes in global order
    YN                  % Y-coordinates of all nodes in global order
    XG                  % X-coordinates of all gaussian integration points in global element order
    YG                  % Y-coordinates of all gaussian integration points in global element order
    UX                  % Total X-displacement of all nodes in global order
    UY                  % Total Y-displacement of all nodes in global order
    ESnG                % Elastic strain tensor of all gaussian integration points, each row represent for a point
    PSnG                % Plastic strain tensor of all gaussian integration points, each row represent for a point
    EPBar               % Accumulative plastic strain
    SG                  % Total Stress tensor of all gaussian integration points, each row represent for a point
    EPArea              % % The total area of elements which have yielded
end

methods
    painter(obj,varargin); 
    plot3d(obj,variable,varargin);                      % varargin is to specify which component of the variable
    plotcontour(obj,variable,meshstructure,varargin);   % varargin is to specify which component of the variable
    plotsurf(obj,variable,meshstructure,varargin);      % varargin is to specify which component of the variable
    plotxy(obj,variable,indices,varargin);              % varargin is to specify which component of the variable
end

end
