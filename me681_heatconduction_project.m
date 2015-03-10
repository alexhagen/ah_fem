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
    student_name = 'alex_hagen';
    disp(student_name)
    
    % Creates a directory with your name .
    if (~exist(student_name,'dir'))
       % Command under Windows
       system(['md img_' student_name]);
    end
    
    
    %% Problem 1q - Quadrilateral Element
    tic;
    close all;
    % use the fem function to import the mesh file from abaqus, construct
    % the stiffness matrix, apply the boundary conditions, assemble into a
    % global matrix, solve for the temperature, and then determine the flux
    % at all mesh points
    filename = 'sq_quad_mod_dirbc';
    inp_filename = ['inp/' filename '.inp'];
    [dir_bcs,neu_bcs,sources,mesh,k] = problem1(inp_filename);
    % Perform fem on this mesh with the given material, dirichlet boundary
    % conditions, neumann boundary conditions, and sources
    [T,x,y,qpp,qppx,qppy] = fem(mesh,k,dir_bcs,neu_bcs,sources);
    plot_t(filename,x,y,T,qpp,qppx,qppy);
    toc;

    %% Problem 1t - Triangular Element
    tic;
    close all;
    % use the fem function to import the mesh file from abaqus, construct
    % the stiffness matrix, apply the boundary conditions, assemble into a
    % global matrix, solve for the temperature, and then determine the flux
    % at all mesh points
    filename = 'sq_tri_mod_dirbc';
    inp_filename = ['inp/' filename '.inp'];
    [dir_bcs,neu_bcs,sources,mesh,k] = problem1(inp_filename);
    % Perform fem on this mesh with the given material, dirichlet boundary
    % conditions, neumann boundary conditions, and sources
    [T,x,y,qpp,qppx,qppy] = fem(mesh,k,dir_bcs,neu_bcs,sources);
    plot_t(filename,x,y,T,qpp,qppx,qppy);
    toc;
    
    %% Problem 2q - Quadrilateral Element with Neumann Boundary Conditions
    filenames = {'sq_quad_low_dirneubc','sq_quad_mod_dirneubc','sq_quad_high_dirneubc'};
    denss = {'Low','Moderate','High'};
    for i = 1:numel(filenames)
        tic;
        close all;
        % use the fem function to import the mesh file from abaqus, construct
        % the stiffness matrix, apply the boundary conditions, assemble into a
        % global matrix, solve for the temperature, and then determine the flux
        % at all mesh points
        filename = char(filenames(i));
        inp_filename = ['inp/' filename '.inp'];
        [dir_bcs,neu_bcs,sources,mesh,k] = problem2(inp_filename);
        % Perform fem on this mesh with the given material, dirichlet boundary
        % conditions, neumann boundary conditions, and sources
        [T,x,y,qpp,qppx,qppy] = fem(mesh,k,dir_bcs,neu_bcs,sources);
        plot_t(filename,x,y,T,qpp,qppx,qppy);
        compare_exact(filename,x,y,T,'sq');
        toc;
    end

    %% Problem 2t - Triangular Element with Neumann Boundary Conditions
    filenames = {'sq_tri_low_dirneubc','sq_tri_mod_dirneubc','sq_tri_high_dirneubc'};
    for i = 1:numel(filenames)
        tic;
        close all;
        % use the fem function to import the mesh file from abaqus, construct
        % the stiffness matrix, apply the boundary conditions, assemble into a
        % global matrix, solve for the temperature, and then determine the flux
        % at all mesh points
        filename = char(filenames(i));
        inp_filename = ['inp/' filename '.inp'];
        [dir_bcs,neu_bcs,sources,mesh,k] = problem2(inp_filename);
        % Perform fem on this mesh with the given material, dirichlet boundary
        % conditions, neumann boundary conditions, and sources
        [T,x,y,qpp,qppx,qppy] = fem(mesh,k,dir_bcs,neu_bcs,sources);
        plot_t(filename,x,y,T,qpp,qppx,qppy);
        compare_exact(filename,x,y,T,'sq');
        toc;
    end
    
    %% Problem 3q
    filenames = {'sqhole_quad_low_dirneubc','sqhole_quad_mod_dirneubc','sqhole_quad_high_dirneubc'};
    for i = 1:numel(filenames)
        tic;
        close all;
        % use the fem function to import the mesh file from abaqus, construct
        % the stiffness matrix, apply the boundary conditions, assemble into a
        % global matrix, solve for the temperature, and then determine the flux
        % at all mesh points
        filename = char(filenames(i));
        inp_filename = ['inp/' filename '.inp'];
        [dir_bcs,neu_bcs,sources,mesh,k] = problem3(inp_filename);
        % Perform fem on this mesh with the given material, dirichlet boundary
        % conditions, neumann boundary conditions, and sources
        [T,x,y,qpp,qppx,qppy] = fem(mesh,k,dir_bcs,neu_bcs,sources);
        plot_t(filename,x,y,T,qpp,qppx,qppy);
        compare_exact(filename,x,y,T,'sqhole');
        toc;
    end
    tic;

    %% Problem 3t
    filenames = {'sqhole_tri_low_dirneubc','sqhole_tri_mod_dirneubc','sqhole_tri_high_dirneubc'};
    for i = 1:numel(filenames)
        tic;
        close all;
        % use the fem function to import the mesh file from abaqus, construct
        % the stiffness matrix, apply the boundary conditions, assemble into a
        % global matrix, solve for the temperature, and then determine the flux
        % at all mesh points
        filename = char(filenames(i));
        inp_filename = ['inp/' filename '.inp'];
        [dir_bcs,neu_bcs,sources,mesh,k] = problem3(inp_filename);
        % Perform fem on this mesh with the given material, dirichlet boundary
        % conditions, neumann boundary conditions, and sources
        [T,x,y,qpp,qppx,qppy] = fem(mesh,k,dir_bcs,neu_bcs,sources);
        plot_t(filename,x,y,T,qpp,qppx,qppy);
        compare_exact(filename,x,y,T,'sqhole');
        toc;
    end
    tic;
end