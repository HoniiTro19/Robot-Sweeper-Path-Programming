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
