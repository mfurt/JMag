function [a, b, d, q, P] = GetData(ang, lin, init)
global N left;
t = textread(ang, '%f', 'whitespace', ' ', 'commentstyle', 'matlab');
% Приводим строчку к приличному виду: переводим градусы и минуты в радианы
% Выделяем градусы и минуты.
deg = t(1:3:length(t));
min = t(2:3:length(t));
sec = t(3:3:length(t));
if sign(deg(2)) == 1
    left = 0;
else
    left = 1;
end;
a = (abs(deg) + min/60 + sec/3600);
b = a(2:length(a));
a = a(1);
a = convang(a, 'deg', 'rad');
b = convang(b, 'deg', 'rad');
d = textread(lin, '%f', 'whitespace', ' ', 'commentstyle', 'matlab');
q = textread(init, '%f', 'whitespace', ' ', 'commentstyle', 'matlab');
N = length(d);
P = zeros(2*N+1);

c = 1;
for i = 1:N+1
    P(i,i) = c/(convang(5/3600, 'deg', 'rad'))^2;
end;
for i = N+2:2*N+1
    P(i,i) = c/(0.02)^2;
end;   
b = fixang(b');
d = d';
q = q';
end

