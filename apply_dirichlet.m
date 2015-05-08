function [k,f] = apply_dirichlet(mesh,k,f)
    % really large number
    C = 1.0E20;
    n_el = numel(mesh);
    for i=1:n_el
        for j=1:mesh(i).gamma_u_mat
            indices = 2*mesh(i).u_indices - 1;
            indices = [indices; 2*mesh(i).u_indices];
            indices = reshape(indices,[1,numel(indices)]);
            k_global(indices,indices) = C;
            f_global(indices) = mesh(i).gammau_i(j).u * C;
            %u_n(indices) = mesh(el).gammau_i(j).u;
        end
    end
end