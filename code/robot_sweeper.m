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









