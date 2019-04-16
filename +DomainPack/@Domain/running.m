%% Method of Domain class to direct the whole solving process
function running(obj,varargin)
%RUNNING Method of 'Domain' class
% Loop over equilibrium iterations for one load increment
% Assemble, solve Linear equation system and update 
if nargin==1
    savemode=1;                                     % default save mode: save results at the end of every incremental simulation
elseif nargin==2
    savemode=varargin{1};                           % user defined save mode
end
% Evaluate external load vector
obj.LinSysCrt.crtRHS_v3;
obj.NewtonRaphson.FullExtLoad=obj.LinSysCrt.RHS;
% For stepwise displacement loading, the external load vector equals to the full load vector for the first calculation
if obj.NewtonRaphson.IncType==2
    obj.NewtonRaphson.ExtLoadVec=obj.NewtonRaphson.FullExtLoad;
end
% Prepare the postprocessor object array
maxinc=obj.NewtonRaphson.MaxInc;
postdict(1:maxinc)=ToolPack.Postprocessor();
obj.Postprocess=postdict;
clear postdict;
%% Loop over Newton_Raphson iteration increments
ind=1;
iinc=1;
while iinc<=obj.NewtonRaphson.NoInc;                % For loop is not proper for this kind loop whose loop number will change during the loop
    obj.NewtonRaphson.IInc=iinc;
    % reset some parameters for converged problem
    obj.NewtonRaphson.switching(2);
%% Loop over equillibrium equations for a load increment
    Ncut=0;                                         % Number of times that increment cut procedure has been activated. 
    while obj.NewtonRaphson.ConvFlag==0             
        % Check if load increment should be cut down
        if obj.NewtonRaphson.IItr>=obj.NewtonRaphson.MaxItr || obj.NewtonRaphson.DivFlag==1
            Ncut=Ncut+1;
            if Ncut>5
                error('The simulation aborted because the increment size is not set to get a convergence.')
            end
            obj.NewtonRaphson.IncCutFlag=1; 
            % cut the size of the current increment 
            obj.NewtonRaphson.autoincrem(1);
            obj.NewtonRaphson.switching(2); 
        end
        obj.NewtonRaphson.IItr=obj.NewtonRaphson.IItr+1;
        obj.LinSysCrt.solve(obj.NewtonRaphson.IncCutFlag,iinc);
        % IMPORTANT ERROR: WITHOUT THIS SENTENCE LHS IS NOT UPDATED AFTER THE FIRST INCREMENT
        obj.NewtonRaphson.IncCutFlag=0;      
        % Compute global internal load force vector
        obj.NewtonRaphson.intforcer;
        obj.NewtonRaphson.converger;       
    end
    %%- store current values of some parameters to the last converged value
    obj.NewtonRaphson.switching(1);
    obj.NewtonRaphson.epnotifier;
    %%- Elongate the size of the next increment
    if obj.NewtonRaphson.IItr<3 && Ncut==0
       obj.NewtonRaphson.autoincrem(2); 
    end
    %%- Store the converged value for postprocessing
    inc=obj.NewtonRaphson.Increments(iinc);
    if savemode==1
        obj.storage(iinc,inc);
        ind=iinc;
    else
        if iinc==1 
            obj.storage(iinc,inc);
        elseif mod(iinc,savemode)||iinc==obj.NewtonRaphson.NoInc
            ind=ind+1;
            obj.storage(iinc,inc,ind);
        end
    end
    iinc=iinc+1;
end
obj.Postprocess=obj.Postprocess(1:ind);
end
