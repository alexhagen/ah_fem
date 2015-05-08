function [ u_n ] = ah_l_fem(mesh)
    %% Set some parameters
    % number of elements
    n_el = numel(mesh);
    % physical constants
    v_0 = 0.33;
    E_0 = 90.0;
    q = 1/3;
    b_i = zeros(2,1);
    % quadrature points
    n_qp = 2;
    n_qp_2d = n_qp*2;
    % number of nodes in our serendipity element
    n_nodes = 8;
    n_global_nodes = mesh(1).n_nodes;
    %% Zero out the displacements
    u_n = zeros(n_nodes*2,1);
    %u_n_gamma_u = u_hat;

    % Zero out the matrices
    k_global = zeros(n_global_nodes*2,n_global_nodes*2);
    f_global = zeros(n_global_nodes*2,1);

    %% iterate over elements
    for el=1:n_el
        % Zero out the matrices
        k_el = zeros(n_nodes*2,n_nodes*2);
        f_omega_el = zeros(n_nodes*2,1);
        f_gamma_el = zeros(n_nodes*2,1);
        hold on;
        plot(mean(mesh(el).x),mean(mesh(el).y),'kd');
        %fprintf('element %d center at %4.2f,%4.2f\n',el,mean(mesh(el).x),mean(mesh(el).y));
        hold on;
        % get the local to global mapping
        % get_local_to_global_mapping();

        %% iterate over quadrature points
        for qp=1:n_qp_2d
            [xi,eta,omega_qp]=get_element_coords(qp);
            %[x,y]=get_point_coords(mesh,el);
            % evaluate j_qp,j_qp_inv,j_qp_det,N,grad_N
            % calculate the shape function at this point
            N = get_shape_function(xi,eta);
            % calculate the gradient of the shape function at this
            % point
            G_el = get_grad_function(xi,eta);
            % calculate the jacobian and its inverse and determinant
            % at this point
            j_qp = get_jacobian(xi,eta,mesh,el);
            % we find the inverse like this because matlab gives us a
            % silly warning if we use the explicit inv() function
            j_qp_inv = j_qp\eye(size(j_qp));
            j_qp_det = det(j_qp);
            % calculate the strain-displacement matrix
            B_el = j_qp_inv * G_el;
            % calculate the strain-displacement matrix
            D_el = (E_0/(1-v_0^2))*[1 v_0 0; v_0 1 0; 0 0 (1-v_0)/2];

            % calculate the element stiffness matrix
            k_el = k_el + B_el' * D_el * B_el * omega_qp * j_qp_det;
            % calculate the element body forcing vector
            f_omega_el = f_omega_el + N' * b_i * omega_qp * j_qp_det;
        end

        %% apply the neumann bc
        f_gamma_el = apply_neumann(mesh,el,f_gamma_el,xi,eta,omega_qp);

        %% Assemble
        [k_global,f_global] = ...
            assemble(mesh,el,k_global,k_el,f_global,f_gamma_el,f_omega_el);
    end

    %% Apply Dirichlet BC
    [k_global,f_global] = apply_dirichlet(mesh,k_global,f_global);

    u_n = k_global\(f_global);
end