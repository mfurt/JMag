%% Основа
global N x y
prec = 1e-9;
% Здесь и далее: a - дирекционные углы, b - внутренние углы
% d - горизонтальные проложения, q - координаты
[a, b, d, qi, P] = GetData('angles.txt', 'linear.txt', 'init.txt');
% rom - ro-metric, измеренные значения параметров
rom = [a b d];
[qe] = SimpleMethod(a, b, d, qi);

%% Основной итерационный процесс
q = qe(3:length(qe))';
qn = q - (R([qi'; q])'*P*R([qi'; q]))^-1*R([qi'; q])'*P*(ro([qi'; q])-rom)';
while max(abs(q-qn)) > prec
    q = qn;
    qn = q - (R([qi'; q])'*P*R([qi'; q]))^-1*R([qi'; q])'*P*(ro([qi'; q])-rom)';
end;

Phi = 0;
dro = ro([qi'; q])-rom;
for i = 1:2*N+1
    Phi = Phi + P(i,i)*dro(i)^2;
end;
sigma = sqrt(Phi)/1;
% Вычисление матрицы ковариации и ошибки определения координат.
D = sigma^2*(R([qi'; qn])'*P*R([qi'; qn]))^-1;
qn = [qi'; qn]';
dq = [];
for i = 1:length(D)
    dq = [dq sqrt(D(i,i))];
end;


% Вычисление площади и её дисперсии
x = qn(1:2:length(qn));
y = qn(2:2:length(qn));
x = [x x(1) x(2)];
y = [y y(1) y(2)];
xe = qe(1:2:length(qe));
ye = qe(2:2:length(qe));
xe = [xe xe(1) xe(2)];
ye = [ye ye(1) ye(2)];
S = 0;
Se =0;
dS = [];
for i = 2:N+1
    S = S + x(i)*(y(i+1) - y(i-1));
    Se = Se + xe(i)*(ye(i+1) - ye(i-1));
    if i ~= N+1
        dS = [dS 0.5*(y(i+1) - y(i-1)) 0.5*(x(i+1) - x(i-1))];
    end
end;
S = abs(S/2);
Se = abs(Se/2);
dx = abs(qe(1:2:length(qe) )- qn(1:2:length(qn))) ;
dy = abs(qe(2:2:length(qe) )- qn(2:2:length(qn))) ;

% Дирекционный угол
for i = 1:N
    Dy(i) = y(i+1) - y(i);
    Dx(i) = x(i+1) - x(i);
    a(i) = atan2(Dy(i), Dx(i));
end;
a = fixang(a);
t = degminsec(a);
adeg = t(:, 1);
amin = t(:, 2); 
asec = t(:, 3);
%% Текстовый вывод
out = fopen('output.txt', 'w');
fprintf(out, 'Уравнивание координат замкнутого теодолитного хода\r\n');
fprintf(out, '\r\nОценка, полученная упрощённым методом\r\n');
fprintf(out, '\t X  \t\tY\r\n');
fprintf(out, '1) %6.2f\t %6.2f  (исходные)\r\n', x(1), y(1));
for i = 2:N
    fprintf(out, '%i) %6.2f\t %6.2f \r\n', i, qe(2*i-1), qe(2*i));
end;
fprintf(out, '\r\nКоординаты, полученные параметрическим методом\r\n');
fprintf(out, '\t X  \t\t\tY\r\n');
fprintf(out, '1) %8.5f\t %8.5f  (исходные)\r\n', x(1), y(1));
for i = 2:N
    fprintf(out, '%i) %8.5f\t %8.5f \r\n', i, x(i), y(i));
end;
fprintf(out, '\r\nРазность результатов\r\n' , dx(1), dy(1));
for i = 2:N
    fprintf(out, '%i) %6.10f\t %6.10f \r\n', i, dx(i), dy(i));
end;
fprintf(out, '\r\nСреднеквадратические ошибки определения координат\r\n');
for i = 2:N
    fprintf(out, '%i) %6.10f\t %6.10f \r\n', i, dq(2*i-3), dq(2*i-2));
end;
fprintf(out, '\r\nПлощадь полигона:\r\nS = %6.4f м^2\r\n', S);
fprintf(out, '\r\nПлощадь полигона (упрощённый метод):\r\nS = %6.4f м^2\r\n', Se);
fprintf(out, '\r\nРазность результатов: %6.10f\r\n' , Se-S);
fprintf(out, '\r\nОценка дисперсии площади: %6.10f\r\n', sqrt(dS*D*dS'));
fprintf(out, '\r\nДирекционные углы:');
for i = 1:N
    fprintf(out, '\r\n%d %d %f ',adeg(i),amin(i),asec(i));
end;
fclose(out);

%% Построить полигон
hold on;
plot(y, x, '-k', 'linewidth', 1.5);
scatter(y(1), x(1), '^k', 'linewidth', 2.5, 'SizeData', 190);
scatter(y(2:N), x(2:N), 'ok', 'linewidth', 1.5, 'SizeData', 90);
axis equal;
grid on;