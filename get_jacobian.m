function [j_qp] = get_jacobian(xi,eta,mesh,el)
    G = get_grad_function(xi,eta);
    P = get_point_function(mesh,el);
    j_qp = G*P;
end