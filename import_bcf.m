function [bcf] = import_bcf(filename,mesh)
    % Isolate the Assembly Portion of the .inp file
    assm = isolate_inp_portion('ASSEMBLY',filename);
    % find each set name
    [start_ind_nset,stop_ind_nset] = regexp(assm,...
        '(\*Nset,\snset\=[A-Za-z1-9\-]*)');
    [start_ind_elset,stop_ind_elset] = regexp(assm,...
        '(\*Elset,\selset\=[A-Za-z1-9\-]*)');
    % for each set name
        for i = 1:numel(start_ind_nset)
            %find the name
            %find the elements
        end
    % Isolate the Boundary Conditions Portion of the .inp file
    bcstr = isolate_inp_portion('BOUNDARY CONDITIONS',filename);
    start_ind_name = findstr('** Name: ',bcstr);
    start_ind_set = findstr('Set-',bcstr);
    for i=1:numel(start_ind_name)
        % find each BC Name
        name=sscanf(bcstr(start_ind_name(i):end),...
            '** Name: %s Type:');
        % find which set it belongs to
        set = sscanf(bcstr(start_ind_set(i):end),...
            '%s,');
        set = set(1:end-1);
        % import the type (11,11?)
        num1 = sscanf(bcstr(start_ind_set(i):end),...
            [set,', %d,']);
        num2 = sscanf(bcstr(start_ind_set(i):end),...
            [set ', ' num2str(num1) ', %d']);
        % import the value (0 or whatever value is given)
        val = sscanf(bcstr(start_ind_set(i):end),...
            [set ', ' num2str(num1) ', ' num2str(num2) ', %f']);
        if isempty(val)
            val = 0.0;
        end
        % Set these all to the boundary conditions structure array
        bc(i).name = name;
        bc(i).set = set;
        bc(i).num1 = num1;
        bc(i).num2 = num2;
        bc(i).val = val;
    end
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