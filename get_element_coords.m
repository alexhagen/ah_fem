function [xi,eta,w] = get_element_coords(qp)
    xi_mat = [-sqrt(3)/3,sqrt(3)/3,sqrt(3)/3,-sqrt(3)/3];
    eta_mat = [-sqrt(3)/3,-sqrt(3)/3,sqrt(3)/3,sqrt(3)/3];
    xi=xi_mat(qp);
    eta=eta_mat(qp);
    w=1;
end