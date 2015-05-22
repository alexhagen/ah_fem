function [] = plot_t(filename,x,y,T,qpp,qppx,qppy)
    student_name = 'alex_hagen';
    %% plot the temperature
    xlin = linspace(min(x),max(x),100);
    ylin = linspace(min(y),max(y),100);
    [X,Y] = meshgrid(xlin,ylin);
    f = scatteredInterpolant(x,y,T);
    delx = max(x)-min(x);
    dely = max(y)-min(y);
    Z = f(X,Y);
    subplot(2,2,2);
    surf(X-delx/200,Y-dely/200,Z,'Linestyle','none');
    hold on;%interpolated
    xlabel('x-coordinate ($x$) [$mm$]','Interpreter','LaTeX');
    ylabel('y-coordinate ($y$) [$mm$]','Interpreter','LaTeX');
    c = colorbar;
    ylabel(c,'Temperature ($T$) [$^{o}C$]','Interpreter','LaTeX');
    title('Temperature','Interpreter','LaTeX');
    view([0,90]);
    axis([-0.6 0.6 -0.6 0.6 min(T) max(T)]);
    %% quiver plot the heat flux
    subplot(2,2,3);
    quiver(qppx,qppy,qpp(1,:),qpp(2,:));
    xlabel('x-coordinate ($x$) [$mm$]','Interpreter','LaTeX');
    ylabel('y-coordinate ($y$) [$mm$]','Interpreter','LaTeX');
    title('Heat Flux','Interpreter','LaTeX');
    axis([-.6 .6 -.6 .6]);
    daspect([1 1 1]);
    set(gcf,'Position',[0 0 200*7.5 200*7.5]);
    pause(1);
    saveas(gcf,['img_' student_name '/' filename '_' student_name],'epsc');
    pause(1);
    saveas(gcf,['img_' student_name '/' filename '_' student_name],'png');
end