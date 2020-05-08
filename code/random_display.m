%% 随机碰撞结果展示
function step_num_random = random_display(Tag, node_num)
%机器人从坐标原点开始清扫，机器人不具有记忆功能
%默认清扫方向是向右，向上，向左，向下
%最大运行次数为深度优先搜索规划路径的运行次数
step_num_random = 0;
sweep_order = [1 0;0 1;-1 0;0 -1];%分别表示向右，向上，向左，向下
figure(2)
[xData, yData] = netplot(Tag);
sign = Tag;
%未清扫的区域为白色，清扫过一次的区域为蓝色，重复清扫过的区域为红色
[map_x, map_y] = size(Tag);
xx = [0 1 1 0];
yy = [0 0 1 1];
patch('xData', xx, 'yData', yy, 'FaceColor', 'b');
pause_time = 0.01;
pause(pause_time)
sign(1, 1) = 1;
index = [1 1];
% for i = 1:max_step
step_num_random = 1;
count = 1;
while count < node_num
    for j = 1:4
        time = ceil(rand * 4);
        dir = sweep_order(time, :);
        if index(1)+dir(1)<1 || index(1)+dir(1)>map_x ||...
                index(2)+dir(2)<1 || index(2)+dir(2)>map_y
            continue
        end
        if Tag(index(1)+dir(1), index(2)+dir(2)) == 1
            continue
        end
        index = index + dir;
        x_temp = [0 1 1 0] +index(1) - 1;
        y_temp = [0 0 1 1] + index(2) - 1;
        if sign(index(1), index(2)) == 0
            patch('xData', x_temp, 'yData', y_temp, 'FaceColor', 'b');
            pause(pause_time)
            sign(index(1), index(2)) = 1;
            step_num_random = step_num_random + 1;
            count = count + 1;
            break
        else
            patch('xData', x_temp, 'yData', y_temp, 'FaceColor', 'r');
            pause(pause_time)
            step_num_random = step_num_random + 1;
            break
        end
    end
end