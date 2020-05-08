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