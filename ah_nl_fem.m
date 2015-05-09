function [ u_global ] = ah_nl_fem(mesh,n_maxiter,method)
    % number of elements
    n_el = numel(mesh);
    %convergence criteria
    epsilon_cr = 1.0E-3;
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
    u_global = zeros(n_global_nodes*2,1);
    %u_n_gamma_u = u_hat;

    %% iterate
    for n=1:n_maxiter
        % Zero out the matrices
        k_global = zeros(n_global_nodes*2,n_global_nodes*2);
        f_global = zeros(n_global_nodes*2,1);
        g_global = zeros(n_global_nodes*2,1);

        %% iterate over elements
        for el=1:n_el
            % Zero out the matrices
            u_n = zeros(n_nodes*2,1);
            k_el = zeros(n_nodes*2,n_nodes*2);
            f_omega_el = zeros(n_nodes*2,1);
            f_gamma_el = zeros(n_nodes*2,1);
            g_el = zeros(n_nodes*2,1);
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
                % calculate the strain at this point
                epsilon_ij = B_el * u_n;
                % calculate the volume change part of the strain
                epsilon_kk = sum(sum(eye(size(epsilon_ij)).*epsilon_ij)) / ...
                    sqrt(numel(epsilon_ij));
                % define the delta operator
                delta_ij = eye(size(epsilon_ij));
                % calculate the deviatoric component of strain
                e_ij = epsilon_ij - (1/3)*epsilon_kk*delta_ij;
                % calculate the equivalent strain
                epsilon_e = sqrt((2/3)*e_ij(1)*e_ij(1));
                % calculate v_TS and E_TS for each method
                if strcmp(method,'newton-raphson')
                    kappa = E_0 * (1+epsilon_e.^q) ./ (3*(1-2*v_0));
                    G_T = E_0 * (1+(q+1)*epsilon_e.^q) ./ (2*(1+v_0));
                    v_TS = (3*kappa - 2*G_T)/(2*(3*kappa + G_T));
                    E_TS = 2*G_T*(1+v_TS);
                elseif strcmp(method,'secant')
                    kappa = E_0 * (1+epsilon_e.^q)./(3*(1-2*v_0));
                    G_S = E_0 * (1+epsilon_e.^q)./(2*(1+v_0));
                    v_TS = v_0;
                    E_TS = E_0 * (1+epsilon_e^q);
                end
                % calculate D_TS
                D_TS = (E_TS)/(1-v_TS^2) * ...
                    [1 v_TS 0; v_TS 1 0; 0 0 (1-v_TS)/2];
                % calculate the element stiffness matrix
                k_el = k_el + (j_qp_inv * G_el)' * D_TS * ...
                    (j_qp_inv * G_el) * omega_qp * j_qp_det;
                % calculate the element body forcing vector
                f_omega_el = f_omega_el + N' * b_i * omega_qp * j_qp_det;
                % calculate D_R
                D_R = (E_0/(1-v_0^2))*[1 v_0 0; v_0 1 0; 0 0 (1-v_0)/2];
                % calculate the element internal force vector
                g_el = g_el + (j_qp_inv * G_el)' * (D_R * epsilon_ij) * ...
                    omega_qp * j_qp_det;
            end

            %% apply the neumann bc
        f_gamma_el = apply_neumann(mesh,el,f_gamma_el,xi,eta,omega_qp);

        %% Assemble
        [k_global,f_global,g_global] = ...
            assemble_nl(mesh,el,...
            k_global,k_el,...
            g_global,g_el,...
            f_global,f_gamma_el,f_omega_el);
        end

        %% Apply Dirichlet BC
        [k_global,f_global,g_global] = ...
            apply_dirichlet_nl(mesh,k_global,f_global,g_global);
        subplot(3,2,5);
        plot(n,sqrt(sum((f_global - g_global).^2))/sqrt(sum(f_global.^2)),'ko');
        hold on;
        if sqrt(sum((f_global - g_global).^2))/sqrt(sum(f_global.^2)) < epsilon_cr
            return;
        end

        if strcmp(method,'newton-raphson')
            % solve K_global * delta_u_n = f_global - g_global
            delta_u_n = k_global\(f_global - g_global);
            % find the next step with u_np1 = u_n + delta_u_n
            u_global = u_global + delta_u_n;
        elseif strcmp(method,'secant')
           % solve K_global * delta_u_n = f_global - g_global
            delta_u_n = k_global\(f_global - g_global);
            % find the next step with u_np1 = u_n + delta_u_n
            u_global = u_global + delta_u_n;
        end
    end
end