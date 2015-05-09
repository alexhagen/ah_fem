function [P] = get_point_function(mesh,el)
    % get the point coordinates from the mesh
    [x,y] = get_point_coords(mesh,el);
    % set them into clockwise order
    x1 = min(x);
    x2 = max(x);
    x3 = max(x);
    x4 = min(x);
    x5 = mean(x);
    x6 = max(x);
    x7 = mean(x);
    x8 = min(x);
    y1 = min(y);
    y2 = min(y);
    y3 = max(y);
    y4 = max(y);
    y5 = min(y);
    y6 = mean(y);
    y7 = max(y);
    y8 = mean(y);
    % construct the P matrix
    P = [x1 0 y1; 0 y1 x1; x2 0 y2; 0 y2 x2; x3 0 y3; 0 y3 x3;...
        x4 0 y4; 0 y4 x4; x5 0 y5; 0 y5 x5; x6 0 y6; 0 y6 x6;...
        x7 0 y7; 0 y7 x7; x8 0 y8; 0 y8 x8];
end