function [grad_N] = get_grad_function(xi,eta)
    dN1dxi = (1-eta)*(2*xi+eta);
    dN1deta = xi*(-xi-2*eta+1)+2*eta;
    dN2dxi = eta*(2*xi-eta-1)-2*xi+2;
    dN2deta = xi*(xi-2*eta-1)+2*eta;
    dN3dxi = (-eta-1)*(2*xi+eta-2);
    dN3deta = xi*(-xi-2*eta+1)+2*eta;
    dN4dxi = eta*(2*xi-eta-1)+2*xi;
    dN4deta = xi*(xi-2*eta-1)+2*eta;
    dN5dxi = 2*xi*(2*eta-2);
    dN5deta = 2*(xi-1)*(xi+1);
    dN6dxi = -2*(eta-1)*(eta+1);
    dN6deta = 2*(2*xi-2)*eta;
    dN7dxi = 2*xi*(-2*eta-2);
    dN7deta = -2*(xi-1)*(xi+1);
    dN8dxi = 2*(eta-1)*(eta+1);
    dN8deta = 2*(2*xi-2)*eta;
    grad_N = 0.25*[dN1dxi 0 dN2dxi 0 dN3dxi 0 dN4dxi 0 ...
        dN5dxi 0 dN6dxi 0 dN7dxi 0 dN8dxi 0; ...
        0 dN1deta 0 dN2deta 0 dN3deta 0 dN4deta ...
        0 dN5deta 0 dN6deta 0 dN7deta 0 dN8deta; ...
        dN1deta dN1dxi dN2deta dN2dxi dN3deta dN3dxi dN4deta dN4dxi ...
        dN5deta dN5dxi dN6deta dN6dxi dN7deta dN7dxi dN8deta dN8dxi];
end