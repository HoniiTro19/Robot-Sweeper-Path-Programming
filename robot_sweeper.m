%% 扫地机器人模拟，主函数
function [step_num_plan, step_num_random] = robot_sweeper()
% 返回深度优先搜索实现全覆盖的运行次数
%将栅格模型的每一个栅格看成一个点
%实际中栅格模型是连续的，在计算机处理时看作离散的

%将栅格模型抽象为标识矩阵，矩阵对应位置的标记表示栅格对应位置的状态
%0表示对应位置无障碍物，1表示对应位置是障碍物

%参数设置
size = 1; %扫地机器人的尺寸
map_x = 20; %房间的尺寸
map_y = 15;

%生成地图网格对应的标识矩阵
tag = zeros(map_x, map_y);
%随机生成障碍物，也是通过矩阵生成
Tag = barrier_generate(tag);
Tag(1, 1) = 0;
%构建图的邻接压缩表
b = graph_convert(Tag);
[re, node_num] = DFS(b, Tag);
step_num_plan = length(re);
result_display(re, Tag);
%进行随机碰撞过程展示
step_num_random = random_display(Tag, node_num);
%% 生成标记矩阵
function Tag = barrier_generate(Tag)
x_num = 3;
y_num = 2;
[map_x, map_y] = size(Tag);
x_1 = round(map_x / x_num); %仅在地图不是太小的时候成立
x_2 = round(map_x * 2 / x_num);
y_1 = round(map_y / y_num);
x_area = [0 x_1 x_2 map_x];
y_area = [0 y_1 map_y];
for i = 1:length(x_area) - 1
    for j = 1:length(y_area) - 1
        temp_x = x_area(i+1) - x_area(i);
        temp_y = y_area(j+1) - y_area(j);
        obs_1 = round(rand(temp_x, temp_y));
        obs_2 = round(rand(temp_x, temp_y));
        obs = conjunction(obs_1, obs_2); %取两次随机结果的合取保证有通路
        Tag([x_area(i)+1:x_area(i+1)], [y_area(j)+1:y_area(j+1)]) = obs;
    end
end
%% 生成障碍物，是barrier_generate的子函数
function obs = conjunction(obs_1, obs_2)
[map_x, map_y] = size(obs_1);
for i = 1:map_x
    for j = i:map_y
        if obs_1(i,j) == 1 & obs_2(i,j) == 1
            obs(i,j) = 1;
        else obs(i,j) = 0;
        end
    end
end
%% 深度优先搜索
function [re, node_num] = DFS(b, Tag)
%传入图的压缩表，传出深度优先搜索的路径
%压缩表中最大值就是邻接矩阵的宽与高
m = max(b(:));
%从邻接压缩表构造图的矩阵表示
A = compresstable2matrix(b, Tag);
node_num = 0;
for i = 1:length(A)
    if isempty(find(A(i,:) == 1)) ~= 1
        node_num = node_num + 1;
    end
end
count = 1;
top = 1;
stack(top) = 1; %将第一个节点入栈
flag = 1; %标记某个节点是否访问过了
re = [];
% node_num
while top ~= 0 %判断堆栈是否为空
    pre_len = length(stack); %搜寻下一个节点前的堆栈长度
    i = stack(top); %取堆栈顶节点
    for j = 1:m
        if A(i,j) == 1 && isempty(find(flag == j,1)) %如果节点相连并且没有访问过
            top = top+1; %扩展堆栈
            stack(top) = j; %新节点入栈
            flag = [flag j]; %对新节点进行标记
            re = [re;i j]; %将边存入结果
            count = count + 1;
            break
        end
    end
    %如果堆栈长度没有增加，则节点开始出栈
    if length(stack) == pre_len
        if count == node_num
            break
        end
        if top ~= 1
            re = [re;stack(top) stack(top-1)];
            stack(top) = [];
            top = top-1;
        else
            %             re = [re;stack(top) 1];
            stack(top) = [];
            top = top-1;
        end
    end
end
% count
%% 图的压缩矩阵与邻接矩阵的转换，是DFS的子函数
function A = compresstable2matrix(b, Tag)
%label是和Tag同维度的矩阵，可以达到的位置是0，不能达到的位置是1
[n, ~] = size(b);
[map_x, map_y] = size(Tag);
m = max(b(:));
A = zeros(m,m);
for i = 1:n
    A(b(i,1),b(i,2)) = 1;
    A(b(i,2),b(i,1)) = 1;
end
%% 将标记矩阵转换为图的压缩矩阵
function b = graph_convert(Tag)
[map_x, map_y] = size(Tag);
b = [];
%遍历每行每列找到零元素所在位置，将相邻的非零元素连起来
for i = 1:map_x
    index = find(Tag(i,:) == 0);
    for j = 1:length(index) - 1
        if ((index(j+1) - index(j) == 1))
            % i表示点所在的行数，index(j)表示点所在的列数
            b = [b;[index(j)+(i-1)*map_y index(j+1)+(i-1)*map_y]];
        else
            continue
        end
    end
end
for i = 1:map_y
    index = find(Tag(:,i) == 0);
    for j = 1:length(index) - 1
        if (index(j+1) - index(j) == 1)
            % i表示点所在的列数，index(j)表示点所在的行数
            b = [b;[i+(index(j)-1)*map_y i+(index(j+1)-1)*map_y]];
        else continue
        end
    end
end
b = sortrows(b, 1);
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