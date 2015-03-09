function [bcf] = import_bcf(filename,mesh)
    % Isolate the Assembly Portion of the .inp file
    assm = isolate_inp_portion('ASSEMBLY',filename)
    % find each set name
    [start_ind_nset,stop_ind_nset] = regexp(assm,...
        '(\*Nset,\snset\=[A-Za-z1-9\-]*)');
    [start_ind_elset,stop_ind_elset] = regexp(assm,...
        '(\*Elset,\selset\=[A-Za-z1-9\-]*)');
    % for each set name
        for i = 1:numel(start_ind_nset)
        %find the name
        sets(i).name = fscanf(assm(start_ind_nset(i):stop_ind_nset(i);
        %find the nodes
        sets(i).nodes = fscanf(assm(start_ind_nset(i):stop_ind_nset(i);
        %find the elements
    % Isolate the Boundary Conditions Portion of the .inp file
    bc = isolate_inp_portion('BOUNDARY CONDITIONS',filename);
    % find each BC Name
    % for each bc name
        % find which set it belongs to
        % import the type (11,11?)
        % import the value (0 or whatever value is given)
    % Isolate the loads conditions portion of the .inp file
    loads = isolate_inp_portion('LOADS',filename);
    % find each load name
    % for each load name
        % find which set it belongs to
        % import the type (S?)
        % import the value (0 or whatever value is given)
    %{
    figure(mesh.fig);
    title('Boundary Conditions and Sources Verification Figure',...
        'Interpreter','LaTeX');
    %}
end