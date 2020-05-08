%% 规划路径结果展示
function result_display(re, Tag)
[map_x, map_y] = size(Tag);
figure(1)
[xData, yData] = netplot(Tag);

%生成栅格编号和地图位置之间的换算矩阵
conversion_matrix = reshape((1:map_x * map_y), map_y, map_x);
conversion_matrix = conversion_matrix';

%模拟机器人的运动路径，扫过的格子用蓝色表示，重复清扫的格子用红色表示
xx = size(re, 1);
x_temp = [0 1 1 0];
y_temp = [0 0 1 1];
patch('xData', x_temp, 'yData', y_temp, 'FaceColor', 'b');
pause_time = 0.5; %运行速率，可以调整
pause(pause_time)
sign = zeros(map_x, map_y);
sign(1, 1) = 1;
for i = 1:xx
    %    temp1 = re(i, :);
    temp2 = re(i, :);
    [xco, yco] = find(conversion_matrix == temp2(1));
    [xco1, yco1] = find(conversion_matrix == temp2(2));
    x_temp = [0 1 1 0] + xco -1;
    y_temp = [0 0 1 1] + yco -1;
    x1_temp = [0 1 1 0] + xco1 -1;
    y1_temp = [0 0 1 1] + yco1 -1;
    if sign(xco1, yco1) == 0 %表示按深度优先顺序走下去
        sign(xco1, yco1) = 1;
        patch('xData', x1_temp, 'yData', y1_temp, 'FaceColor', 'b');
        pause(pause_time)
    else %表示回溯过程
        patch('xData', x1_temp, 'yData', y1_temp, 'FaceColor', 'r');
        pause(pause_time)
    end
end