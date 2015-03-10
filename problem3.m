function [dir_bcs,neu_bcs,sources,mesh,k] = problem3(filename)
    % Import of mesh from file specified by filename
    mesh = import_mesh(filename);
    % Application of materials
    % import conductivity from the file
    k = readinp('*Conductivity',filename);
    a = 0.25;
    b = 0.5;
    fun1 = @(x,y) a.^2 + b.^2 + y.^2 ...
        - 2*a*sqrt(b.^2 + y.^2);
    strfun1 = '\frac{9}{16}^{2} + y^{2} - \frac{1}{4}\sqrt{\frac{1}{4} + y^{2}}';
    fun2 = @(x,y) (2*a)./sqrt(x.^2 + y.^2)-4;
    strfun2 = '\frac{0.25}{\sqrt{x^{2}+y{2}}}-4';
    fun3 = @(x,y) 2*b*(1-a/sqrt(x.^2+y.^2));
    strfun3 = '1-\frac{0.25}{\sqrt{x^{2}+y{2}}}';
    fun4 = @(x,y) 2*b*(a/sqrt(x.^2+y.^2) - 1);
    strfun4 = '\frac{0.25}{\sqrt{x^{2}+y{2}}}-1';
    % set up dirichlet boundary condtions
    % Apply the Dirichlet boundary condition to the inner boundary with
    % value 0.0
    dir_bcs(1) = dir_bc(mesh,@(x,y) abs((x.^2 + y.^2) - a^2) < 0.01,@(x,y) 0.0,'0');
    % Apply the Dirichlet boundary condition to the left boundary
    dir_bcs(2) = dir_bc(mesh,@(x,y) x==-b,fun1,strfun1);
    % Apply the Dirichlet boundary condition to the right boundary
    dir_bcs(3) = dir_bc(mesh,@(x,y) x==b,fun1,strfun1);
    % Apply the Neumann boundary condition so the top and bottom boundaries
    neu_bcs(1) = neu_bc(mesh,@(x,y) y==0.5,fun4,strfun4,0);
    neu_bcs(2) = neu_bc(mesh,@(x,y) y==-0.5,fun3,strfun3,0);
    % Set up sources to the whole domain with value 2
    sources = bf(mesh,fun2,strfun2);
end