clc; clear; close all;
mesh = fem_mesh(2);

tic;
u=ah_l_fem(mesh);
toc
plot_fem(mesh,u);
tic;
u=ah_nl_fem(mesh,10,'newton-raphson');
toc
plot_fem(mesh,u);
tic;
u=ah_nl_fem(mesh,10,'secant');
toc
plot_fem(mesh,u);
