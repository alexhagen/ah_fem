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
    % use the fem function to import the mesh file from abaqus, construct
    % the stiffness matrix, apply the boundary conditions, assemble into a
    % global matrix, solve for the temperature, and then determine the flux
    % at all mesh points
    filename = 'sqhole_quad_low_dirneubc';
    [T,qpp] = fem(['inp/' filename '.inp']);
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