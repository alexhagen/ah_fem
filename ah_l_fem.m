function [ u_n ] = ah_l_fem(mesh)
    %% Set some parameters

    %% Zero out the displacements
    u_n = 0;
    u_n_gamma_u = u_hat;

    %% iterate
    for n=1:n_maxiter
        % Zero out the matrices
        k_global = zeros(8,8);
        f_global = zeros(1,8);
        g_global = zeros(1,8);

        %% iterate over elements
        for el=0:mesh.n_el
            % Zero out the matrices
            k_el = zeros(8,8);
            f_omega_el = zeros(1,8);
            f_gamma_el = zeros(1,8);
            g_el = zeros(1,8);
            % get the local to global mapping
            % get_local_to_global_mapping();
            %% iterate over quadrature points
            for i=1:n_qp
                for j=1:n_qp
                    [xi,eta]=get_element_coords(i,j);
                    [x,y]=get_point_coords(mesh,el);
                    % evaluate j_qp,j_qp_inv,j_qp_det,N,grad_N
                    N = get_shape_function(xi,eta);
                    grad_N = get_grad_function(xi,eta);
                    j_qp = get_jacobian(xi,eta,x,y);
                    j_qp_inv = inv(j_qp);
                    j_qp_det = det(j_qp);
                    % epsilon_ij = j_qp_inv * grad_N * u_n
                    % e_ij = epsilon_ij - (1/3)*epsilon_kk*delta_ij
                    % e_e = sqrt((2/3)*e_ij*e_ij);
                    % evaluate v_TS, E_TS, D_TS sequentially
                    % K_el = K_el + (j_qp_inv * grad_N)' * D_TS * (j_qp_inv * grad_N) * omega_qp * j_qp_det
                    % f_omega_el = f_omega_el + N' * b_i * omega_qp * j_qp_det
                    % g_el = g_el + (j_qp_inv * N)' * D_R * epsilon_ij * omega_qp * j_qp_det;
                end
            end

            %% apply the neumann bc
            for el_gamma = 1:mesh.n_el_gamma_t
                % determine the orientation of the element el and its
                % corresponding edges on gamma_t
                for qp=1:n_qp_gamma
                    % j_qp_gamma_det = sqrt((delxdelxi^2 + delydeleta^2)) or sqpt((delxdeleta^2 + delydelxi^2));
                    % evaluate corresponding N|gamma_q or N|gamma_q
                    % f_gamma_el = f_gamma_el + N' * t_i * omega_qp * j_qp_gamma_det;
                end
            end

            %k_global[global_indices] = k_global[global_indices] + k_el;
            %f_global[global_indices] = f_global[global_indices] + f_gamma_el + f_omega_el;
            %g_global[global_indices] = g_global[global_indices] + g_el;
        end

        %% Apply Dirichlet BC
        for DOF_i = gamma_u
            %k_global[global_indicies] = C;
            %f_global[global_indicies] = g_global[global_indices];
        end

        if norm(f_global - g_global)/norm(f_global) < epsilon_cr
            return;
        end

        if strcmp(method,'newton-raphson')
            % solve K_global * delta_u_n = f_global - g_global
            delta_u_n = K_global\(f_global - g_global);
            % u_np1 = u_n + delta_u_n
            u_n = u_n + delta_u_n;
        elseif strcmp(method,'secant')
            % calculate delta_g_global
            % solve K_global * delta_u_n = delta_g_global
            delta_u_n = delta_g_global\delta_g_global;
            % u_np1 = u_n + delta_u_n
            u_n = u_n + delta_u_n;
        end
    end
end