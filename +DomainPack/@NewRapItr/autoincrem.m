function autoincrem( obj, mode )
%AUTOINCREM Method of class NewRapItr, accumulated increments
iinc=obj.IInc;
switch mode
    %  Auto Cut the current load increment factor by 50 percent
    case 1
    fprintf('Increment size is cut at No.%d increment\n',obj.IInc);
    if iinc==1
        newincrem=0.5*obj.Increments(iinc);
        obj.Increments=newincrem:newincrem:1;
    elseif iinc>1
        step=0.5*(obj.Increments(iinc)-obj.Increments(iinc-1));
        newincrem=obj.Increments(iinc-1)+step;
        front=obj.Increments(1:iinc-1);
        back=newincrem:step:1;
        obj.Increments=[front,back];
    end
    if length(obj.Increments)>obj.MaxInc
        warning('Too many increments are involved.\n');
    end
    % Auto elongate the next load incremnt factor by 25 percent
    case 2
    fprintf('Increment size is elongated after No.%d increment\n',obj.IInc);
    step=1.1*(obj.Increments(iinc+1)-obj.Increments(iinc));
    newincrem=obj.Increments(iinc)+step;
    front=obj.Increments(1:iinc);
    back=newincrem:step:1;
    obj.Increments=[front,back];
end
% Guarantee that the last component of the increments array is "1".
if obj.Increments(end)<1
   obj.Increments=[obj.Increments,1];
end
end


