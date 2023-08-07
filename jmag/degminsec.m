function [ f ] = degminsec( a )
for i = 1:length(a)
a(i) = convang(a(i), 'rad', 'deg');
deg = fix(a(i));
min = fix((a(i) - deg)*60);
sec = (a(i) - deg - min/60)*3600;
fixang(a(i));
if i ~= 1 
    f = [f; deg abs(min) abs(sec)];
else
    f = [deg abs(min) abs(sec)];
end;

end

