function solve(obj,varargin)
%% Method of Linear systerm Creator
    % For non-linear returning process, RHS has been called in the returing method for nonliner problems
       cutflag=varargin{1};
       iinc=varargin{2};
       % calculate LHS for the first load increment or when the increment cut procedure is not activated.
       if cutflag==0 || iinc==1
           obj.crtLHS; 
       end
   % This appbound_v2 step is also necessary for displacemnt increment type, 
   % since LHS need to be applied boundary condition also.
   obj.appbound_v2;                  
   obj.Unknowns=obj.LHS\obj.RHS;
   obj.TotDisp=obj.TotDisp+obj.Unknowns;
   obj.upconf;
end