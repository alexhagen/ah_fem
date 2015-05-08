function plot_fem(mesh,u)
    for el = 1:numel(mesh)
        fac = [1 5 2 6 3 7 4 8];
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
        vert = [x1 y1; x2 y2; x3 y3; x4 y4; x5 y5; x6 y6; x7 y7; x8 y8];
        gi = mesh(el).global_indices;
        indices = [gi*2-1; gi*2];
        indices = reshape(indices,[1,numel(indices)]);
        u_n = u(indices);
        fvcx = u_n(1:2:end);
        fvcy = u_n(2:2:end);
        fvc = sqrt(fvcx.^2 + fvcy.^2);
        patch('Faces',fac,'Vertices',vert,'FaceColor','interp',...
            'FaceVertexCData',fvc);
        hold on;
    end
end