function [x,y] = get_point_coords(mesh,el)
    x=mesh(el).x;
    y=mesh(el).y;
end