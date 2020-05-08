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