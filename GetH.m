function [ A, h, b ] = GetH( hfile )
t = textread(hfile, '%f', 'whitespace', ' ', 'commentstyle', 'matlab');
N = length(t) - 1;

b = zeros(N, 1);
h = zeros(N, 1);

b(1) = t(1);
b(N) = -t(1);

A = zeros(N, N-1);
for i = 1:N
    if i ~= N
        A(i,i) = 1;
    end
    
    if i ~= 1
        A(i, i-1) = -1;
    end
end

for i = 2:N+1
    h(i-1) = t(i);
end

