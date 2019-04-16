function   calarea( obj )
%CALAREA Method of Elem_2d_EP to calculate the area of the element
x=obj.X;
y=obj.Y;
obj.Area=0.5*abs((x(2)-x(4))*(y(3)-y(1))-(x(3)-x(1))*(y(2)-y(4)));
end

