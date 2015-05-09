function [mesh,n_global_nodes] = fem_mesh(filename)
    mesh = {};
    % import full node matrix
    nodes = readinp('*Node',filename);
    nodes(:,2) = 2 * (nodes(:,2) + 0.5);
    nodes(:,3) = nodes(:,3) + 0.5;
    % find number of nodes
    mesh(1).n_nodes = size(nodes,1);
    % import full element matrix
    elements_local = readinp('*Element',filename);
    % find number of elements
    mesh(1).n_el = size(elements_local,1);
    % construct mesh
    for i = 1:size(elements_local,1)
        % find element number
        mesh(i).el_no = elements_local(i,1);
        % determine if quad or tri element
        mesh(i).el_type = 'quadratic quadrilateral';
        el_no_corners = 4;
        % add the node values
        mesh(i).global_indices = elements_local(i,2:end);
        % add the global x values
        mesh(i).x = [min(nodes(mesh(i).global_indices,2)) ...
            max(nodes(mesh(i).global_indices,2))];
        mesh(i).y = [min(nodes(mesh(i).global_indices,3)) ...
            max(nodes(mesh(i).global_indices,3))];
        mesh(i).gamma_mat = 0;
        mesh(i).gammat_i = {};
        mesh(i).gamma_u_mat = 0;
        mesh(i).gammau_i = {};
        mesh(i).rl = [];
        mesh(i).dir = [];
        for gi = mesh(i).global_indices
            if nodes(gi,2) == 0
                % add this to the dirichlet boundary
                mesh(i).gamma_u_mat = mesh(i).gamma_u_mat + 1;
                mesh(i).gammau_i(mesh(i).gamma_u_mat).u = [0];
                mesh(i).u_indices = gi;
                mesh(i).rl = [mesh(i).rl -1];
                mesh(i).dir = [mesh(i).dir 0];
            end
            if nodes(gi,2) == 2
                % add this to the neumann boundary
                mesh(i).gamma_mat = mesh(i).gamma_mat + 1;
                mesh(i).gammat_i(mesh(i).gamma_mat).t = [20E6;0];
                mesh(i).gammat_i(mesh(i).gamma_mat).ind = [2 3 6];
                mesh(i).rl = [mesh(i).rl 1];
                mesh(i).dir = [mesh(i).dir 0];
            end
        end
    end
end

%{
    mesh = {};
    mesh(1).n_nodes = 21;
    mesh(1).x=[0,1];
    mesh(1).y=[0,0.5];
    mesh(1).global_indices = [1 6 21 15 5 17 20 16];
    mesh(1).gamma_mat = 0;
    mesh(1).gammat_i = {};
    mesh(1).gamma_u_mat = 1;
    mesh(1).gammau_i = {};
    mesh(1).gammau_i(1).u = [0];
    mesh(1).u_indices = mesh(1).global_indices(find(mesh(1).x == 0));
    mesh(1).rl = [-1];
    mesh(1).dir = [0];
    mesh(2).x=[1,2];
    mesh(2).y=[0,0.5];
    mesh(2).global_indices = [6 2 9 21 7 8 18 17];
    mesh(2).gamma_mat = 1;
    mesh(2).gammat_i = {};
    mesh(2).rl = [1];
    mesh(2).dir = [0];
    mesh(2).gamma_u_mat = 0;
    mesh(2).gammau_i = {};
    mesh(2).gamma_u = 0;
    mesh(2).gammat_i(1).t = [20;0];
    mesh(2).gammat_i(1).ind = [2 3 6];
    mesh(3).x=[1,2];
    mesh(3).y=[0.5,1];
    mesh(3).global_indices = [21 9 3 12 18 10 11 19];
    mesh(3).gamma_mat = 1;
    mesh(3).gammat_i = {};
    mesh(3).rl = [1];
    mesh(3).dir = [0];
    mesh(3).gamma_u_mat = 0;
    mesh(3).gammau_i = {};
    mesh(3).gamma_u = 0;
    mesh(3).gammat_i(1).t = [20;0];
    mesh(3).gammat_i(1).ind = [2 3 6];
    mesh(4).x=[0,1];
    mesh(4).y=[0.5,1];
    mesh(4).global_indices = [15 21 12 4 20 19 13 14];
    mesh(4).gamma_mat = 0;
    mesh(4).gammat_i = {};
    mesh(4).rl = [];
    mesh(4).dir = [];
    mesh(4).gamma_u_mat = 1;
    mesh(4).gammau_i = {};
    mesh(4).gammau_i(1).u = [0];
    mesh(4).u_indices = mesh(4).global_indices(find(mesh(4).x == 0));
%}