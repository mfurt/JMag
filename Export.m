global N x y
f = figure;
hold on;
plot(y, x, '-k', 'linewidth', 1.5);
scatter(y(1), x(1), '^k', 'linewidth', 2.5, 'SizeData', 190);
scatter(y(2:N), x(2:N), 'ok', 'linewidth', 1.5, 'SizeData', 90);
axis equal;
grid on;
print(f, '-dpng', 'output.png');
delete(f);