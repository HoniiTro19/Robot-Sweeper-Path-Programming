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