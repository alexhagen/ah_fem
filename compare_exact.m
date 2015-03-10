function [] = compare_exact(filename,x,y,T,soln)
    student_name = 'alex_hagen';
    if strcmp(soln,'sq')
        s = 2.0;
        k = 1.0;
        b = 0.5;
        c1 = -2 + s*b/k;
        c2 = s*b^2/(2*k) - c1*b;
        T_exact = -s*x.^2/(2*k) + c1*x + c2;
    else
        T_exact = (sqrt(x.^2 + y.^2) - 0.25).^2;
    end
    error = abs(T - T_exact);
    %% plot the temperature
    xlin = linspace(min(x),max(x),100);
    ylin = linspace(min(y),max(y),100);
    [X,Y] = meshgrid(xlin,ylin);
    f = scatteredInterpolant(x,y,error);
    delx = max(x)-min(x);
    dely = max(y)-min(y);
    Z = f(X,Y);
    subplot(2,2,4)
    surf(X-delx/200,Y-dely/200,Z,'Linestyle','none');
    hold on;%interpolated
    xlabel('x-coordinate ($x$) [$mm$]','Interpreter','LaTeX');
    ylabel('y-coordinate ($y$) [$mm$]','Interpreter','LaTeX');
    c = colorbar;
    ylabel(c,'Error ($T-T_{exact}$) [$^{o}C$]','Interpreter','LaTeX');
    title('Error','Interpreter','LaTeX');
    view([0,90]);
    daspect([1 1 1]);
    axis([-0.6 0.6 -0.6 0.6 min(error) max(error)]);
    set(gcf,'Position',[0 0 200*7.5 200*7.5]);
    pause(1);
    saveas(gcf,['img_' student_name '/' filename '_' student_name],'epsc');
    pause(1);
    saveas(gcf,['img_' student_name '/' filename '_' student_name],'png');
end