function [T,x_global,y_global,qpp,qppx,qppy]=fem(mesh,k,dir_bcs,neu_bcs,sources)
    %% Construction of stiffness matrix
    % set a symbolic xi and eta variable so we can evaluate later - we
    % arent actually doing any integrating with the symbolic variables
    syms xi;
    syms eta;
    syms zeta;
    % find the maximum stiffness element
    max_K_el = 0;
    % iterate over all mesh elements
    for i = 1:mesh.n_el
        i
        % preallocate the stiffness and forcing matrices
        K_el = zeros(mesh.elements(i).n_nodes,mesh.elements(i).n_nodes);
        f_omega_el = zeros(mesh.elements(i).n_nodes,1);
        f_gamma_el = zeros(mesh.elements(i).n_nodes,1);
        % Find the symbolic N, G, J, and B matrices
        [N_el_sym,G_el_sym,J_el_sym,qp_xi,qp_eta,omega] = ...
            element_type(mesh.elements(i));
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
                % find the current global coordinates
                delx = mesh.elements(i).global_corner_x(3) - ...
                    mesh.elements(i).global_corner_x(1);
                x = mesh.elements(i).global_corner_x(1) + ...
                    delx * qp_xi(qp);
                dely = mesh.elements(i).global_corner_y(3) - ...
                    mesh.elements(i).global_corner_y(1);
                y = mesh.elements(i).global_corner_y(1) + ...
                    dely * qp_eta(qp);
                % fill the forcing vector
                f_omega_el = f_omega_el + ...
                    feval(sources(n).value,x,y) * N_el' ...
                    * omega(qp) * J_el_det;
            end
        end
        % set the elemental stiffness matrix into a container
        mesh.elements(i).K_el = K_el;
        mesh.elements(i).f_omega_el = f_omega_el;
        mesh.elements(i).f_gamma_el = f_gamma_el;
        mesh.elements(i).B_el = B_el;
        % remember the maximum overall stiffness element
        if max_K_el < max(abs(K_el(:)))
            max_K_el = max(abs(K_el(:)));
        end
    end
    
    %% Applying Neumman BC
    for i = 1:numel(neu_bcs)
        for j = 1:numel(neu_bcs(i).elements)
            % Find the symbolic N, G, J, and B matrices
            [N_el_sym,G_el_sym,J_el_sym,~,~,~] = ...
                element_type(mesh.elements(neu_bcs(i).elements(j).num));
            % there is always only one boundary in each element that has a
            % boundary condition applied, so over this boundary, determine
            % the shape function and omegas for one dimension
            qp_eta = [-1/sqrt(3) 1/sqrt(3)];
            omega = [ 1.0 1.0 ];
            for qp = 1:numel(qp_eta)
                horizontal = neu_bcs(i).horizontal;
                % find the current global coordinates
                el_no = neu_bcs(i).elements(j).num;
                if ~horizontal
                    N = eval(subs(N_el_sym,[xi eta],...
                        [ neu_bcs(i).elements(j).xi(qp) qp_eta(qp) ]));
                    J = eval(subs(J_el_sym,[xi eta],...
                        [ neu_bcs(i).elements(j).xi(qp) qp_eta(qp) ]));
                    J_det = sqrt(J(1,1)^2 + J(2,1)^2);
                    x = neu_bcs(i).elements(j).x;
                    y = neu_bcs(i).elements(j).y;
                else
                    N = eval(subs(N_el_sym,[xi eta],...
                        [ qp_eta(qp) neu_bcs(i).elements(j).xi(qp) ]));
                    J = eval(subs(J_el_sym,[xi eta],...
                        [ qp_eta(qp) neu_bcs(i).elements(j).xi(qp) ]));
                    J_det = sqrt(J(1,2)^2 + J(2,2)^2);
                    x = neu_bcs(i).elements(j).x;
                    y = neu_bcs(i).elements(j).y;
                end
                for p = 1:numel(neu_bcs(i).elements(j).local_nodes)
                    q = feval(neu_bcs(i).value,x(p),y(p));
                    f_gamma_el(neu_bcs(i).elements(j).local_nodes(p)) = ...
                        f_gamma_el(neu_bcs(i).elements(j).local_nodes(p)) ...
                        - q * N(neu_bcs(i).elements(j).local_nodes(p)) ...
                        * omega(qp) * J_det;
                end
                
            end
            mesh.elements(neu_bcs(i).elements(j).num).f_gamma_el = ...
                f_gamma_el;
        end
    end
        
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
                    C*dir_bcs(i).elements(j).local_values(k);
            end
        end
    end
    
    %% Assembly
    % Preallocate the global stiffness and forcing matrices
    K_global = zeros(mesh.n_nodes,mesh.n_nodes);
    B_global = zeros(mesh.n_nodes,2);
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
            B_global(global_node_nos(j),:) = ...
                B_global(global_node_nos(j),:) + ...
                mesh.elements(i).B_el(:,j)';
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
    % solve the flux from the B_el matrix
    qppx = []; qppy = []; qpp = [];
    for i = 1:numel(mesh.elements)
        x_el = [mesh.elements(i).global_corner_x' mesh.elements(i).global_midside_x'];
        y_el = [mesh.elements(i).global_corner_y' mesh.elements(i).global_midside_y'];
        avg_x = sum(x_el)/numel(x_el);
        avg_y = sum(y_el)/numel(y_el);
        qppx = [ qppx avg_x ];
        qppy = [ qppy avg_y ];
        qpp = [qpp ...
            -k*mesh.elements(i).B_el*T([ mesh.elements(i).global_corner_node_no mesh.elements(i).global_midside_node_no]) ];
    end
end