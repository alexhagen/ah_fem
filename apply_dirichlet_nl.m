function [k_global,f_global,g_global] = ...
    apply_dirichlet_nl(mesh,k_global,f_global,g_global)
    % really large number
    C = 1.0E20;
    n_el = numel(mesh);
    for i=1:n_el
        for j=1:mesh(i).gamma_u_mat
            indices = 2*mesh(i).u_indices - 1;
            indices = [indices; 2*mesh(i).u_indices];
            indices = reshape(indices,[1,numel(indices)]);
            k_global(indices,indices) = C;
            f_global(indices) = g_global(indices);
        end
    end