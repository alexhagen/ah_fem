function [P] = get_point_function(mesh,el)
    % get the point coordinates from the mesh
    [x,y] = get_point_coords(mesh,el);
    % set them into clockwise order
    x1 = x(1);
    x2 = x(2);
    x3 = x(2);
    x4 = x(1);
    x5 = mean(x);
    x6 = x(2);
    x7 = mean(x);
    x8 = x(1);
    y1 = y(1);
    y2 = y(1);
    y3 = y(2);
    y4 = y(2);
    y5 = y(1);
    y6 = mean(y);
    y7 = y(2);
    y8 = mean(y);
    % construct the P matrix
    P = [x1 0 y1; 0 y1 x1; x2 0 y2; 0 y2 x2; x3 0 y3; 0 y3 x3;...
        x4 0 y4; 0 y4 x4; x5 0 y5; 0 y5 x5; x6 0 y6; 0 y6 x6;...
        x7 0 y7; 0 y7 x7; x8 0 y8; 0 y8 x8];
end