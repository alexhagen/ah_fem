function plot_fem(mesh,u)
%% plot in the x direction
    
    for el = 1:numel(mesh)
        fac = [1 5 2 6 3 7 4 8];
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
        vert = [x1 y1; x2 y2; x3 y3; x4 y4; x5 y5; x6 y6; x7 y7; x8 y8];
        gi = mesh(el).global_indices;
        indices = [gi*2-1; gi*2];
        indices = reshape(indices,[1,numel(indices)]);
        u_n = u(indices);
        fvcx = u_n(1:2:end);
        fvcy = u_n(2:2:end);
        subplot(3,2,1);
        patch('Faces',fac,'Vertices',vert,'FaceColor','interp',...
            'FaceVertexCData',fvcx);
        subplot(3,2,3);
        patch('Faces',fac,'Vertices',vert,'FaceColor','interp',...
            'FaceVertexCData',fvcy);
        hold on;
        subplot(3,2,2);
    end
    subplot(3,2,1)
    title('Displacment $u_{x}$','interpreter','latex');
    xlabel('x-coordinate ($x$) [$cm$]','interpreter','latex');
    ylabel('y-coordinate ($y$) [$cm$]','interpreter','latex');
    subplot(3,2,3)
    title('Displacment $u_{y}$','interpreter','latex');
    xlabel('x-coordinate ($x$) [$cm$]','interpreter','latex');
    ylabel('y-coordinate ($y$) [$cm$]','interpreter','latex');
    subplot(3,2,2)
    title('Stress $\sigma_{x}$','interpreter','latex');
    xlabel('x-coordinate ($x$) [$cm$]','interpreter','latex');
    ylabel('y-coordinate ($y$) [$cm$]','interpreter','latex');
    subplot(3,2,4)
    title('Stress $\sigma_{y}$','interpreter','latex');
    xlabel('x-coordinate ($x$) [$cm$]','interpreter','latex');
    ylabel('y-coordinate ($y$) [$cm$]','interpreter','latex');
    subplot(3,2,6)
    title('Stress $\sigma_{xy}$','interpreter','latex');
    xlabel('x-coordinate ($x$) [$cm$]','interpreter','latex');
    ylabel('y-coordinate ($y$) [$cm$]','interpreter','latex');
end