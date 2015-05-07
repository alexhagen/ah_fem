mesh = {};
mesh(1).x=[0,2];
mesh(1).y=[0,1];


tic;
u=ah_nl_fem(mesh,10,'newton-raphson');
toc
plot_fem(mesh,u);
tic;
u=ah_nl_fem(mesh,10,'secant');
toc
plot_fem(mesh,u);
