function [ a ] = fixang( a )
for i = 1:length(a)
    while a(i) > 2*pi
        a(i) = a(i)- 2*pi;
    end;
    while a(i) < 0
        a(i) = a(i) + 2*pi;
    end;
end

