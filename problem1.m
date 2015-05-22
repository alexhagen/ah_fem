function [dir_bcs,neu_bcs,sources,mesh,k] = problem1(filename)
    % Import of mesh from file specified by filename
    mesh = import_mesh(filename);
    % Application of materials
    % import conductivity from the file
    k = readinp('*Conductivity',filename);
    % Application of boundary conditions
    % Note that these conditions are provided in the .inp file, but the
    % abaqus layout is very clunky.  I found it more elegant to hardcode
    % these values in.
    b = 0.5;
    % set up dirichlet boundary condtions
    % Apply the Dirichlet boundary condition to the right boundary with
    % value 1.0
    dir_bcs(1) = dir_bc(mesh,@(x,y) x==b,@(x,y) 1.0,'1');
    % Apply the Dirichlet boundary condition to the left boundary
    dir_bcs(2) = dir_bc(mesh,@(x,y) x==-b,@(x,y) 0.0,'0');
    % Set up sources to the whole domain with value 0.0
    sources = bf(mesh,@(x,y) 0.0,'0');
    % there are no neumann boundary conditions here
    neu_bcs = [];
end