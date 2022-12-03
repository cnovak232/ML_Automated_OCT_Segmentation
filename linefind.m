function [out] = linefind(alg_marks,sz)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

openings = alg_marks.bruch_op;
center = sz(2)/2;
l_count = 1;
r_count = 1;
left = [];
right = [];
for i = 1:size(openings,1)
    if openings(i,1) < center
        left(l_count,:) = openings(i,:);
        l_count = l_count +1 ;
    else
        right(r_count,:) = openings(i,:);
        r_count = r_count + 1;
    end
end
left_opening = mean(left,1);
right_opening = mean(right,1);
bruch = [left_opening;right_opening];
alg_marks.bruch_op = bruch;


points{1} = alg_marks.bruch_mem_left;
points{2} = alg_marks.bruch_mem_right;
points{3} = alg_marks.chor_scl_left;
points{4} = alg_marks.chor_scl_right;
points{5} = alg_marks.ant_lam_lim;


for i = 1:5
    point_array = points{i};
    windowing_image = zeros(sz);
    for j = 1:size(point_array,1)
        windowing_image(point_array(j,1),point_array(j,2)) = 1;
    end
    window_out = [0,0];
    density = 0;
    for j = 1:size(windowing_image,1)-14
        for k = 1:size(windowing_image,2)-14
            window = windowing_image(j:j+14,k:k+14);
            sum_win = sum(sum(window,1),2);
            if sum_win > density
                window_out = [j,k];
                density = sum_win;
            end
        end
    end
    points_out = [];
    count = 1;
    if i == 5
        for j = 1:size(point_array,1)
            if point_array(j,2) > (window_out(2)-30) && point_array(j,2) < (window_out(2)+45)
                points_out(count,1:2) = point_array(j,:);
                count = count + 1;
            end
        end
    else
        for j = 1:size(point_array,1)
            if point_array(j,2) > (window_out(2)-10) && point_array(j,2) < (window_out(2)+15)
                points_out(count,1:2) = point_array(j,:);
                count = count + 1;
            end
        end
    end
    if i == 1
        points_out = [points_out; left_opening];
    elseif i == 2
        points_out = [points_out; right_opening];
    end
    points_cell{i} = points_out;
    line_eq = polyfit(points_out(:,1),points_out(:,2),3);
    x = 1:1:sz(2);
    for j = 1:sz(2)
        y(j) = line_eq(2)*x(j)^2+line_eq(3)*x(j)+line_eq(4)+line_eq(1)*x(j)^3;
    end
    lin_points = [x',y'];
    if i == 1 || i == 3
        min_ind = min(points_out(:,1));
        max_ind = left_opening(1);
        
    elseif i == 2 || i == 4
        min_ind = right_opening(1);
        max_ind = max(points_out(:,1));
    else
        min_ind = min(points_out(:,1));
        max_ind = max(points_out(:,1));
    end
    count = 1;
    for j = 1:size(lin_points,1)
        if lin_points(j,1) < max_ind && lin_points(j,1) > min_ind
            points_q(count,1:2) = lin_points(j,:);
            count = count+1;
        end
    end
    jump = round(size(points_q,1)/15);
    count = 1;
    for j = 1:jump:size(points_q,1)
        p_out(count,:) = points_q(j,:);
        count = count + 1;
    end
    p_out = [p_out;points_q(size(points_q,1),:)];
    points_cell{i} = p_out;
    
end

alg_marks.bruch_mem_left = points_cell{1};
alg_marks.bruch_mem_right = points_cell{2};
alg_marks.chor_scl_left = points_cell{3};
alg_marks.chor_scl_right = points_cell{4};
alg_marks.ant_lam_lim = points_cell{5};

out = alg_marks;
end