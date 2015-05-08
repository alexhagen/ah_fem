function [f_gamma_el] = apply_neumann(mesh,el,f_gamma_el,xi,eta,omega_qp)
    n_qp = 2;
    for i=1:mesh(el).gamma_mat
        % check if element is sideways or upright
        dir = mesh(el).dir(i);
        % determine whether it is the element's right or left boundary
        rl = mesh(el).rl(i);
        for qp=1:n_qp
            if dir == 0
                N = get_shape_function(rl,eta);
                % calculate the jacobian and its inverse and determinant
                % at this point
                j_qp = get_jacobian(rl,eta,mesh,el);
                j_qp_gamma_det = sqrt((j_qp(1,1)^2 + j_qp(1,2)^2));
            else
                N = get_shape_function(xi,rl);
                % calculate the jacobian and its inverse and determinant
                % at this point
                j_qp = get_jacobian(xi,rl,mesh,el);
                j_qp_gamma_det = sqrt((j_qp(2,2)^2 + j_qp(2,1)^2));
            end
            indices = 2*mesh(el).gammat_i(i).ind - 1;
            indices = [ indices; indices+1 ];
            indices = reshape(indices,[1,numel(indices)]);
            f_gamma_el(indices) = f_gamma_el(indices) + N(:,indices)' * rl * mesh(el).gammat_i(i).t * omega_qp * j_qp_gamma_det;
        end
    end
end