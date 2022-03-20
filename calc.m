function [ output_args ] = calc(anglesfile, linearfile, initfile, hfile, noprint, nolink)
%% Основа
global N x y
prec = 1e-9;
% Здесь и далее: a - дирекционные углы, b - внутренние углы
% d - горизонтальные проложения, q - координаты
[a, b, d, qi, P] = GetData(anglesfile, linearfile, initfile);

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

%% Решение задачи нивелирования:
% Для начала - методом НК с весами:
[A, h, b_h] = GetH(hfile);
%P = diag(ones(length(A),1));
c = sum(d)/length(d);
P = diag((c./d).^2);

h_LS = (A'*P*A)^-1*A'*P*(h+b_h); % Координаты полученные уравниванием методом НК

% Теперь простым
h = h - sum(h)/length(h);
h_simple(1) = b_h(1) + h(1);
for i = 2:N-1
    h_simple(i) = h_simple(i-1) + h(i);
end;

Phi = sum(P.^2*((A*h_LS - b_h) - h).^2);
sigma0 = sqrt(Phi/4);
Dout = sigma0^2*(A'*P*A)^-1;
sigma1 = sqrt(diag(Dout));

dh = abs(h_simple' - h_LS);


%% Построить полигон
hold on;

for i = 1:N
    if (find(nolink==i+1))
    else
    plot(y(i:i+1), x(i:i+1), '-k', 'linewidth', 1.5);
    end
end
scatter(y(1), x(1),'filled','black', '^k', 'linewidth', 2.5, 'SizeData', 100);
for i = 2:N-1
    if (find(noprint==i))
    else
        scatter(y(i:i+1), x(i:i+1),'filled','black', 'ok', 'linewidth', 1.5, 'SizeData', 50);
    end
end
%ylim([min(x) - 25 max(x) + 25]);
axis equal;
grid on;

% Добавим высоты:
center = [mean(x) mean(y)];
h_out = [b_h(1); h_LS];

for i = 1:N
    if (find(noprint==i))
    else
        text(y(i) + 5, x(i), num2str(h_out(i), '%4.3f'));
    end
end


end

