function  returning( obj )
%RETURNING Method of Retuner class
% Loop over equilibrium iterations for one load increment
% Assemble, solve Linear equation system and update 
% Evaluate external load vector
    obj.LinSysCrt.crtRHS_v3;
    obj.FullExtLoad=obj.LinSysCrt.RHS;
    % For stepwise displacement loading, the external load vector equals to
    % the full load vector for the first calculation
    if obj.IncType==2
        obj.ExtLoadVec=obj.FullExtLoad;
    end
% Loop over Newton_Raphson iteration increments
for iinc=1:length(obj.Increments)
    obj.IInc=iinc;
    % reset some parameters for converged problem
    obj.switching(2);
% Loop over equillibrium equations for a load increment
    Ncut=0;                        % Number of times that increment cut procedure has been activated. 
    while obj.ConvFlag==0             
        % Check if load increment should be cut down
        if obj.IItr>=obj.MaxItr || obj.DivFlag==1
            Ncut=Ncut+1;
            if Ncut>5
                error('The simulation aborted because the increment size is not set to get a convergence.')
            end
            obj.IncCutFlag=1; 
            % cut the size of the current increment 
            obj.autoincrem(1);
            obj.switching(2); 
        end
        obj.IItr=obj.IItr+1;
        obj.LinSysCrt.solve(obj.IncCutFlag,obj.IInc);
        % IMPORTANT ERROR: WITHOUT THIS SENTENCE LHS IS NOT UPDATED AFTER THE FIRST INCREMENT
        obj.IncCutFlag=0;      
        % Compute global internal load force vector
        obj.intforcer;
        obj.converger;       
    end
% store current values of some parameters to the last converged value
    obj.switching(1);
    obj.epnotifier;
    % Elongate the size of the next increment
    if obj.IItr<3 && Ncut==0
       obj.autoincrem(2); 
    end
end

end



