function [T,qpp]=fem(filename)
    %% Import of mesh from file specified by filename
    mesh = import_mesh(filename);
    %% Import of boundary conds and sources from file specified by filename
    % import conductivity from the file
    k = readinp('*Conductivity',filename);
    % import Temperature boundary conditions
    %boundary = readinp('*Boundary',filename)
    %% Construction of stiffness matrix
    % allocate a structure to hold all of the elemental stiffness matrices
    for n = 1:mesh.n_el
        % preallocate the stiffness and forcing matrices
        K_el = zeros(mesh.elements(n).n_nodes,mesh.elements(n).n_nodes);
        f_omega_el = zeros(mesh.elements(n).n_nodes,1);
        f_gamma_el = zeros(mesh.elements(n).n_nodes,1);
        % iterate over every quadrature point
        for qp = 1:n_qp
            % find the quadrature point coordinates
            % evaluate J, J_inv, and J_det
            % iterate over every node
            for i= 1:n_node
                % evaluate shape function and gradient of shape function at
                % the specified quadrature point
            end
            % iterate over every node
            for i = 1:n_node
                %iteratre over every node
                for j = 1:n_node
                    % Fill the stiffness matrix
                    K_el(i,j) = K_el(i,j) + k(J_inv*N_i_grad(xi,eta))^T ...
                        * (J_inv*N_i_grad(xi,eta))*omega_qp*J_det;
                end
                % fill the forcing matrix
                f_omega_el(i) = f_omega_el(i) + s*N_i(xi,eta)^T ...
                    * omega_qp *J_det;
            end
        end
    end
    %{
    %% Applying Neumman BC
    %% Applying Dirichlet BC
    %% Assembly
    %% Solving
    % using matlab's backdivision operator to solve the system [K]T=f where
    % K is n x n, and T and f are n x 1
    T = K_global\f_global;
    % solving the flux from the temperature distribution found in previous
    % step
    dTdx =;
    dTdy =;
    qpp =;
    return [T,qpp];
    %}
end