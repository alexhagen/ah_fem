function [ u_n ] = ah_nl_fem(mesh,n_maxiter,method)
    %% Set some parameters
    n_el = numel(mesh);
    C = 1.0E9;
    v_0 = 0.33;
    E_0 = 90.0;
    q = 1/3;
    epsilon_cr = 1.0E-2;
    n_qp = 2;
    
    %% Zero out the displacements
    u_n = zeros(4,3);
    %u_n_gamma_u = u_hat;

    %% iterate
    for n=1:n_maxiter
        % Zero out the matrices
        k_global = zeros(8,8);
        f_global = zeros(8,1);
        g_global = zeros(8,1);

        %% iterate over elements
        for el=1:n_el
            % Zero out the matrices
            k_el = zeros(8,8);
            f_omega_el = zeros(8,1);
            f_gamma_el = zeros(8,1);
            g_el = zeros(8,1);
            
            % get the local to global mapping
            % get_local_to_global_mapping();
            
            %% iterate over quadrature points
            for qp=1:n_qp
                [xi,eta,omega_qp]=get_element_coords(qp);
                %[x,y]=get_point_coords(mesh,el);
                % evaluate j_qp,j_qp_inv,j_qp_det,N,grad_N
                % calculate the shape function at this point
                N = get_shape_function(xi,eta);
                % calculate the gradient of the shape function at this
                % point
                G_el = get_grad_function(xi,eta);
                % calculate the jacobian and it's inverse and determinant
                % at this point
                j_qp = get_jacobian(xi,eta,mesh,el);
                j_qp_inv = j_qp\eye(size(j_qp));
                j_qp_det = det(j_qp);
                % calculate the strain replacement matrix at this point
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
                epsilon_e = sqrt((2/3)*e_ij*e_ij);
                % calculate v_TS and E_TS for each method
                if strcmp(method,'newton-raphson')
                    kappa = E_0 * (1+epsilon_e^q) / (3*(1-2*v_0));
                    G_T = E_0 * (1+(q+1)*epsilon_e^q) / (2*(1+v_0));
                    v_TS = (3*kappa - 2*G_T)/(2*(3*kappa + G_T));
                    E_TS = 2*G_T*(1+v_TS);
                elseif strcmp(method,'secant')
                    kappa = E_0 * (1+epsilon_e^q)/(3*(1-2*v_0));
                    G_S = E_0 * (1+epsilon_e^q)/(2*(1+v_0));
                    v_TS = v_0;
                    E_TS = E_0 * (1+epsilon_e^q);
                end
                % calculate D_TS
                D_TS = (E_TS)/(1-v_TS^2) * ...
                    [1 v_TS 0; v_TS 1 0; 0 0 (1-v_TS)/2];
                % calculate the element stiffness matrix
                K_el = K_el + (j_qp_inv * grad_N)' * D_TS * ...
                    (j_qp_inv * grad_N) * omega_qp * j_qp_det;
                % calculate the element body forcing vector
                f_omega_el = f_omega_el + N' * b_i * omega_qp * j_qp_det;
                % calculate D_R
                D_R = (E_TS)/(1-v_TS^2) * ...
                    [1 v_TS 0; v_TS 1 0; 0 0 (1-v_TS)/2];
                % calculate the element internal force vector
                g_el = g_el + (j_qp_inv * N)' * D_R * epsilon_ij * ...
                    omega_qp * j_qp_det;
            end

            %% apply the neumann bc
            %{
            for el_gamma = 1:mesh.n_el_gamma_t
                % determine the orientation of the element el and its
                % corresponding edges on gamma_t
                for qp=1:n_qp_gamma
                    % j_qp_gamma_det = sqrt((delxdelxi^2 + delydeleta^2)) or sqpt((delxdeleta^2 + delydelxi^2));
                    % evaluate corresponding N|gamma_q or N|gamma_q
                    % f_gamma_el = f_gamma_el + N' * t_i * omega_qp * j_qp_gamma_det;
                end
            end
            %}

            %% Assemble
            k_global = k_global + k_el;
            f_global = f_global + f_gamma_el + f_omega_el;
            g_global = g_global + g_el;
        end

        %% Apply Dirichlet BC
        for DOF_i = mesh(el).gamma_u
            k_global(DOF_i,DOF_i) = C;
            f_global(DOF_i) = g_global(DOF_i);
        end

        if norm(f_global - g_global)/norm(f_global) < epsilon_cr
            return;
        end

        if strcmp(method,'newton-raphson')
            % solve K_global * delta_u_n = f_global - g_global
            delta_u_n = K_global\(f_global - g_global);
            % find the next step with u_np1 = u_n + delta_u_n
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