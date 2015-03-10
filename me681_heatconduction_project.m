%-------------------------------------------------------------------------%
%                ME 681 Finite and Boundary Element Methods               %
%                        Project function template                        %
%                                                                         %
% Note: 1) Use this function as a starting point for your code            %
%       2) Make sure all other functions that you need to run your code   %
%          are called from here. When the code is tested only this        %
%          function will be run.                                          %
%-------------------------------------------------------------------------%

function me681_heatconduction_project()
    %% Project Initialization
    % Input names
    disp('This project was done by')
    student_name = 'Alex_Hagen';
    disp(student_name)
    
    % Creates a directory with your name .
    if (~exist(student_name,'dir'))
       % Command under Windows
       system(['md ', student_name]);
    end
    
    %% Problem 1q - Quadrilateral Element
    clf;
    % use the fem function to import the mesh file from abaqus, construct
    % the stiffness matrix, apply the boundary conditions, assemble into a
    % global matrix, solve for the temperature, and then determine the flux
    % at all mesh points
    %filename = 'sq_tri_mod_dirbc';
    filename = 'test_tri'
    [T,x,y] = fem(['inp/' filename '.inp']);
    xlin = linspace(min(x),max(x),100);
    ylin = linspace(min(y),max(y),100);
    [X,Y] = meshgrid(xlin,ylin);
    f = scatteredInterpolant(x,y,T);
    delx = max(x)-min(x);
    dely = max(y)-min(y);
    Z = f(X,Y);
    T
    figure(2)
    surf(X-delx/200,Y-dely/200,Z,'Linestyle','none');
    hold on;%interpolated
    xlabel('x');
    ylabel('y');
    zlabel('T');
    view([0,90]);
    axis([-0.6 0.6 -0.6 0.6 min(T) max(T)]);
    %{
    % determine the temperature distribution and flux from the analytical
    % solution for this problem
    [T_exact,qpp_exact] = exact('sq_dirbc');
    % compare the approximate solution to the exact solution
    
    % plot the requested plots
    plot_T(T,filename);
    plot_q(qpp,filename);
    %% Problem 1t - Triangular Element
    % use the fem function to import the mesh file from abaqus, construct
    % the stiffness matrix, apply the boundary conditions, assemble into a
    % global matrix, solve for the temperature, and then determine the flux
    % at all mesh points
    filename = 'sq_tri_mod_dirbc';
    [T,qpp] = fem(['inp/' filename '.inp']);
    % determine the temperature distribution and flux from the analytical
    % solution for this problem
    [T_exact,qpp_exact] = exact('sq_dirbc');
    % compare the approximate solution to the exact solution
    
    % plot the requested plots
    plot_T(T,filename);
    plot_q(qpp,filename);
    
    %% Problem 2ql - Quadrilateral Low Density Element
    % use the fem function to import the mesh file from abaqus, construct
    % the stiffness matrix, apply the boundary conditions, assemble into a
    % global matrix, solve for the temperature, and then determine the flux
    % at all mesh points
    filename = 'sq_quad_mod_dirbc';
    [T,qpp] = fem(['inp/' filename '.inp']);
    % determine the temperature distribution and flux from the analytical
    % solution for this problem
    [T_exact,qpp_exact] = exact('sq_dirneubc');
    % compare the approximate solution to the exact solution
    
    % plot the requested plots and save to a file
    plot_T(T,filename);
    plot_q(qpp,filename);
    %}
    
    
end