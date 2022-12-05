function [out] = linefind(alg_marks,sz,n_poly)
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
if isempty(left)
    left = [240,240];
elseif isempty(right)
    right = [550,240];
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
    for j = 1:size(windowing_image,1)-50
        for k = 1:size(windowing_image,2)-14
            window = windowing_image(j:j+50,k:k+14);
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
            if j > 450
                if point_array(j,2) > (window_out(2)-120) && point_array(j,2) < (window_out(2))
                    points_out(count,1:2) = point_array(j,:);
                    count = count + 1;
                end
            elseif point_array(j,2) > (window_out(2)-30) && point_array(j,2) < (window_out(2)+45)
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
   
    % Fitting polynomials
    %n_poly = 16; % degree of polynomial
    n_poly_list = n_poly:-1:0;
    y = zeros(1,sz(2));
    % Fit function
    line_eq = polyfit(points_out(:,1),points_out(:,2),n_poly);

    % Creating it in points
    x = 1:1:sz(2);
    for j = 1:sz(2)
        for k = 1:n_poly+1
        y(j) = y(j) + x(j)^n_poly_list(k)*line_eq(k);
        end
    end

    finding = 3:3:sz(2);
    % Linearizing missing data
    for j = 1:size(points_out)
      marking = points_out(j,1);
      ind = find(finding == marking);
      finding(ind) = 0;
    end

    not_missing = find(finding == 0);
    for j = 1:length(not_missing)-1
        if not_missing(j+1) - not_missing(j) >= 3
            low_pixel = not_missing(j)*3;
            high_pixel = not_missing(j+1)*3;
            in_low = find(points_out(:,1) == low_pixel);
            in_high = find(points_out(:,1) == high_pixel);
            points_x = [points_out(in_low,1);points_out(in_high,1)];
            points_y = [points_out(in_low,2);points_out(in_high,2)];
            line_eq = polyfit(points_x,points_y,1);
            x_slot = low_pixel:1:high_pixel;
            for k = 1:length(x_slot)
                y(x_slot(k)) = x_slot(k)*line_eq(1)+line_eq(2);
            end
        end
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
    num_pts = 15; % number of points to output to screen
    jump = round(size(points_q,1)/num_pts);
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