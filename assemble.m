function [k_global,f_global] = assemble(mesh,el,k_global,k_el,f_global,f_gamma_el,f_omega_el)
gi = mesh(el).global_indices;
indices = [gi*2-1; gi*2];
indices = reshape(indices,[1,numel(indices)]);
k_global(indices,indices) = ...
    k_global(indices,indices) + ...
    k_el;
f_global(indices) = ...
    f_global(indices) + f_gamma_el + f_omega_el;
end