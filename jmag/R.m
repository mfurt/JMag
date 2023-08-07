function R = R(q)
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

R = zeros(2*N+1,2*N-2);
R(1,1) = -sin(a(1))/d(1);
R(1,2) = cos(a(1))/d(1);
R(2,1) = sin(a(1))/d(1);
R(2,2) = -cos(a(1))/d(1);
R(2, 2*N-3) = sin(a(N))/d(N);
R(2, 2*N-2) = -cos(a(N))/d(N);
for i = 3:N+1
    if i ~= 3
        R(i, 2*i-7) = sin(a(i-2))/d(i-2);
        R(i, 2*i-6) = -cos(a(i-2))/d(i-2);
    end;
    R(i,2*i-5) = -sin(a(i-2))/d(i-2) - sin(a(i-1))/d(i-1); 
    R(i,2*i-4) = cos(a(i-2))/d(i-2) + cos(a(i-1))/d(i-1);
    if i ~= N + 1
        R(i, 2*i-3) = sin(a(i-1))/d(i-1);
        R(i, 2*i-2) = -cos(a(i-1))/d(i-1);
    end;
end;
R(N+2, 1) = (x(2) - x(1))/d(1);
R(N+2, 2) = (y(2) - y(1))/d(1);
for i = 2:N-1
    R(N+1+i, 2*i-3) = -(x(i+1)-x(i))/d(i);
    R(N+1+i, 2*i-2) = -(y(i+1)-y(i))/d(i);
    R(N+1+i, 2*i-1) = (x(i+1)-x(i))/d(i);
    R(N+1+i, 2*i) = (y(i+1)-y(i))/d(i);
end;
R(2*N+1, 2*N-3) = -(x(N)-x(N-1))/d(N-1);
R(2*N+1, 2*N-2) = -(y(N)-y(N-1))/d(N-1);

if left == 1
    R(2:N+1, :) = R(2:N+1, :) * -1;
end

