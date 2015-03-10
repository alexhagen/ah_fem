function [T,x_global,y_global]=fem(filename)
    %% Import of mesh from file specified by filename
    mesh = import_mesh(filename);
    %% Application of boundary conditions and materials
    % import conductivity from the file
    k = readinp('*Conductivity',filename);
    % Note that these conditions are provided in the .inp file, but the
    % abaqus layout is very clunky.  I found it more elegant to hardcode
    % these values in.
    % Apply the Dirichlet boundary condition to the left boundary with
    % value 0.0
    dir_bcs(1) = dir_bc(mesh,@(x,y) x==-0.5,0.0);
    % Apply the Dirichlet boundary condition to the right boundary with
    % value 1.0
    dir_bcs(2) = dir_bc(mesh,@(x,y) x==0.5,1.0);
    % Apply any neumann boundary conditions here

    % Apply any source conditions here
    sources = [];
    %% Construction of stiffness matrix
    % set a symbolic xi and eta variable so we can evaluate later - we
    % arent actually doing any integrating with the symbolic variables
    syms xi;
    syms eta;
    syms zeta;
    % find the maximum stiffness element
    max_K_el = 0;
    for i = 1:mesh.n_el
        i
        % preallocate the stiffness and forcing matrices
        K_el = zeros(mesh.elements(i).n_nodes,mesh.elements(i).n_nodes);
        f_omega_el = zeros(mesh.elements(i).n_nodes,1);
        f_gamma_el = zeros(mesh.elements(i).n_nodes,1);
        % Find the symbolic N, G, J, and B matrices
        if (strcmp(mesh.elements(i).el_type,'quadratic quadrilateral'))
            % set up the constants for 2x2 gauss quadrature
            qp_xi = [-1/sqrt(3) 1/sqrt(3) 1/sqrt(3) -1/sqrt(3)];
            qp_eta = [-1/sqrt(3) -1/sqrt(3) 1/sqrt(3) 1/sqrt(3)];
            omega = [1 1 1 1];
            % Make the shape function for the 8 noded element
            N_el_sym = 0.25*[...
                -(1-xi)*(1-eta)*(1+xi+eta) ...
                -(1+xi)*(1-eta)*(1-xi+eta) ...
                -(1+xi)*(1+eta)*(1-xi-eta) ...
                -(1-xi)*(1+eta)*(1+xi-eta) ...
                2*(1-xi)*(1+xi)*(1-eta) ...
                2*(1+xi)*(1-eta)*(1+eta) ...
                2*(1-xi)*(1+xi)*(1+eta) ...
                2*(1-xi)*(1-eta)*(1+eta)];
            % Find the derivative of this for the 8 noded element
            G_el_sym =0.25*[...
                -(eta - 1)*(eta + xi + 1) - (eta - 1)*(xi - 1) ...
                (eta - 1)*(eta - xi + 1) - (eta - 1)*(xi + 1) ...
                (eta + 1)*(eta + xi - 1) + (eta + 1)*(xi + 1) ...
                (eta + 1)*(xi - eta + 1) + (eta + 1)*(xi - 1) ...
                2*(xi - 1)*(eta - 1) + 2*(eta - 1)*(xi + 1) ...
                -2*(eta - 1)*(eta + 1) ...
                -2*(xi - 1)*(eta + 1) - 2*(eta + 1)*(xi + 1) ...
                2*(eta - 1)*(eta + 1); ...
                -(xi - 1)*(eta + xi + 1) - (eta - 1)*(xi - 1) ...
                (xi + 1)*(eta - xi + 1) + (eta - 1)*(xi + 1) ...
                (xi + 1)*(eta + xi - 1) + (eta + 1)*(xi + 1) ...
                (xi - 1)*(xi - eta + 1) - (eta + 1)*(xi - 1) ...
                2*(xi - 1)*(xi + 1) ...
                -2*(xi + 1)*(eta - 1) - 2*(xi + 1)*(eta + 1) ...
                -2*(xi - 1)*(xi + 1) ...
                2*(xi - 1)*(eta - 1) + 2*(xi - 1)*(eta + 1)];
            % Construct the J matrix, which is the gradient matrix times
            % the global values
            J_el_sym = G_el_sym * ...
                [ mesh.elements(i).global_corner_x' ...
                mesh.elements(i).global_midside_x';
                mesh.elements(i).global_corner_y' ...
                mesh.elements(i).global_midside_y' ]';
        else
            % set up the constants for 4 point gauss quadrature
            qp_xi = [0.6,0.2,0.2,1/3];
            qp_eta = [0.2,0.6,0.2,1/3];
            omega = [25/48 25/48 25/48 -27/48];
            % Make the shape function for the 6 noded element
            zeta = 1 - xi - eta;
            N_el_sym = [...
                xi*(2*xi - 1) ...
                eta*(2*eta - 1) ...
                zeta*(2*zeta - 1) ...
                4*xi*eta ...
                4*eta*zeta ...
                4*xi*zeta ];
            % Find the derivative of this for the 6 noded element
            G_el_sym = [ diff(N_el_sym,xi); ...
                diff(N_el_sym,eta); ];
            % find the zeta values, which are equal to 1 - xi - eta
            global_zeta = ones(1,numel(N_el_sym)) - ...
                [ mesh.elements(i).global_corner_x' ...
                mesh.elements(i).global_midside_x' ] - ...
                [ mesh.elements(i).global_corner_y' ...
                mesh.elements(i).global_midside_y' ];
            % Construct the J matrix, which is the gradient matrix times
            % the global values    
            J_el_sym = G_el_sym * ...
                [ mesh.elements(i).global_corner_x' ...
                mesh.elements(i).global_midside_x';
                mesh.elements(i).global_corner_y' ...
                mesh.elements(i).global_midside_y' ]';
        end
        % iterate over every quadrature point
        for qp = 1:numel(qp_xi)
            % evaluate J, J_inv, and J_det
            J_el = eval(subs(J_el_sym, [xi eta],...
                [qp_xi(qp) qp_eta(qp)]));
            J_el_inv = inv(J_el);
            J_el_det = det(J_el);
            % evaluate the shape and gradient functions
            N_el = eval(subs(N_el_sym, [xi eta],...
                [qp_xi(qp) qp_eta(qp)]));
            G_el = eval(subs(G_el_sym, [xi eta],...
                [qp_xi(qp) qp_eta(qp)]));
            % Build the global gradient function
            B_el = J_el_inv * G_el;
            % Fill the stiffness matrix
            K_el = K_el + k * ...
                B_el' * B_el * omega(qp) * J_el_det;
            for n = 1:numel(sources)
                % fill the forcing vector
                f_omega_el = f_omega_el + s * N_el' ...
                    * omega(qp) * J_el_det;
            end
        end
        % set the elemental stiffness matrix into a container
        mesh.elements(i).K_el = K_el;
        mesh.elements(i).f_omega_el = f_omega_el;
        mesh.elements(i).f_gamma_el = f_gamma_el;
        % remember the maximum overall stiffness element
        if max_K_el < max(abs(K_el(:)))
            max_K_el = max(abs(K_el(:)));
        end
    end
    %% Applying Neumman BC
    %% Applying Dirichlet BC
    C = max_K_el * 1E7;
    % iterate over each boundary condition
    for i = 1:numel(dir_bcs)
        % iterate over every element affected
        for j = 1:numel(dir_bcs(i).elements)
            % iterate over every node in that element
            for k = 1:numel(dir_bcs(i).elements(j).local_nodes)
                % apply C*T to the stiffness and forcing matrix at the
                % indices corresponding to the local nodes
                mesh.elements(dir_bcs(i).elements(j).num)...
                    .K_el(dir_bcs(i).elements(j).local_nodes(k),...
                    dir_bcs(i).elements(j).local_nodes(k)) = ...
                    C;
                mesh.elements(dir_bcs(i).elements(j).num)...
                    .f_gamma_el(dir_bcs(i).elements(j).local_nodes(k)) = ...
                    C*dir_bcs(i).value;
            end
        end
    end
    %% Assembly
    % Preallocate the global stiffness and forcing matrices
    K_global = zeros(mesh.n_nodes,mesh.n_nodes);
    x_global = zeros(mesh.n_nodes,1);
    y_global = zeros(mesh.n_nodes,1);
    f_global = zeros(mesh.n_nodes,1);
    for i = 1:numel(mesh.elements)
        global_node_nos = [ mesh.elements(i).global_corner_node_no ...
                mesh.elements(i).global_midside_node_no ];
        for j = 1:numel(global_node_nos)
            for k = 1:numel(global_node_nos)
                K_global(global_node_nos(j),global_node_nos(k)) = ...
                    K_global(global_node_nos(j),global_node_nos(k)) + ...
                    mesh.elements(i).K_el(j,k);
            end
            f_global(global_node_nos(j),1) = ...
                f_global(global_node_nos(j),1) + ...
                mesh.elements(i).f_omega_el(j) + ...
                mesh.elements(i).f_gamma_el(j);
            x_el = [ mesh.elements(i).global_corner_x ...
                mesh.elements(i).global_midside_x ];
            y_el = [ mesh.elements(i).global_corner_y ...
                mesh.elements(i).global_midside_y ];
            x_global(global_node_nos(j),1) = x_el(j);
            y_global(global_node_nos(j),1) = y_el(j);
        end
    end
    
    
    %% Solving
    % using matlab's backdivision operator to solve the system [K]T=f where
    % K is n x n, and T and f are n x 1
    T = K_global\f_global;
    % solving the flux from the temperature distribution found in previous
    % step
    %dTdx =;
    %dTdy =;
    %qpp =;
end