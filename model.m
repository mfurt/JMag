global N
clc;
clear;
q = [900 300 1400 700 1100 1300 600 1100 400 500];
N = length(q)/2;
ro = ro(q);
mb = convang(30/3600, 'deg', 'rad');
md = 0.2;
fprintf('Углы: \n')
for i = 1:N+1
     ro(i) = ro(i) + mb*(1-2*rand);
     fprintf('%i %i %2.12f \n', degminsec(ro(i)))
end;
fprintf('\nГоризонтальные проложения: \n')
for i = N+2:2*N+1
     ro(i) = ro(i) + md*(1-2*rand);
     fprintf('%4.12f\n', ro(i))
end;