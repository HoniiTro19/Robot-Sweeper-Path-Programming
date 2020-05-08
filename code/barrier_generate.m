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