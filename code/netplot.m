%% 绘制地图以及障碍物的位置
function [xData, yData] = netplot(Tag)
[map_x, map_y] = size(Tag);
x = 0:map_x;
y = 0:map_y;
x1 = [x(1) x(end)]';
y1 = [y(1) y(end)]';
%产生所有网格线的数据xData,yData
x2 = repmat(x1, 1, length(y)-2);
x3 = repmat(x(2) : x(end-1), 2, 1);
xData = [x2 x3];
y2 = repmat(y1, 1, length(x)-2);
y3 = repmat(y(2):y(end-1), 2, 1);
yData = [y3 y2];
h = line(xData, yData);
box on;
set(h, 'Color', 'k');
%绘出障碍物的位置，用黑色区域表示
[co_x, co_y] = find(Tag == 1);
% [co_x co_y]
for i = 1:length(co_x)
    x = [0 1 1 0] + co_x(i) -1;
    y = [0 0 1 1] + co_y(i) -1;
    patch('xData', x, 'yData', y, 'FaceColor', 'k');
end