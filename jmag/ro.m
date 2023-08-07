function ro = ro(q)
global N left;
x = q(1:2:length(q));
y = q(2:2:length(q));
x = [x x];
y = [y y];

for i = 1:N
    dx = x(i+1) - x(i);
    dy = y(i+1) - y(i);
    d(i) = sqrt(dx^2 + dy^2);
    a(i) = atan2(dy, dx);
end;
a = fixang(a);

if left == 0
    b(1) = a(N) - a(1) + pi;
    for i = 2:N
        b(i) = a(i-1) - a(i) + pi;
    end;
else
    b(1) = a(1) - a(N) - pi;
    for i = 2:N
        b(i) = a(i) - a(i-1) - pi;
    end;
end;

ro = [a(1) fixang(b) d];
end

