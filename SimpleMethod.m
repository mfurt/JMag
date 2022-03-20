function [q] = SimpleMethod( a, b, d, q )
global N  left;
% Вычисление невязки и исправление внутренних углов:
fBeta = (sum(b) - pi*(N-2))/N;
b = b - fBeta;

% Вычисление дирекционных углов
if left == 0
    for i = 2:N
        a(i) = a(i-1) + pi - b(i);
    end;
else
    for i = 2:N
    a(i) = a(i-1) + pi + b(i);
    end;
end;
a = fixang(a);
% Горизонтальные приложения и иже с ними
% Конструкция d = [d d] треба чтобы не выходить за пределы
d = [d d];
for i = 1:N
    dx(i) = d(i)*cos(a(i));
    dy(i) = d(i)*sin(a(i));
end;
dx = dx + sum(dx)/N;
dy = dy + sum(dy)/N;
x = q(1);
y = q(2);
for i = 2:N
    x = x + dx(i-1);
    y = y + dy(i-1);
    q = [q x y];
end;
f = fopen('SMout.txt', 'w');
fprintf(f, 'Точка: \t Исправленый угол \t Дирекционный угол \t dx \t dy\n');
for i = 1:N
fprintf(f, '%i \t\t %f° \t %f° \t %f \t %f\n', i, 360-b(i)*180/pi, a(i)*180/pi, dx(i), dy(i));
end;
fclose(f);
end

