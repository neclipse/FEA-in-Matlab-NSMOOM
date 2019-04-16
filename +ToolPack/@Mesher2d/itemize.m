function id=itemize(obj,x,y)
% This is a method of Mesher2d to retrieve the index of a node
tol=1e-6;
id=[0,0];                                % arbitrary condition to go to while loop
while ~isscalar(id)                      % id is not a scalar: multiple points have been found
ind= find(abs(obj.VX-x)<1e-5);           % Find the index of nodes with VX==x
indt=logical(abs(obj.VY(ind)-y)<1e-5);   % Search within the found index for nodes with VY==y
id=ind(indt);                            % Convert logical value to original index
tol=tol/10;
end
end