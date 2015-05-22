function [bc] = neu_bc(mesh,criteria,value,string,horizontal)
    % initialize the x and y coords for the boundary condition
    bc.x = []; bc.y = [];
    % initialize an element counter
    j=1;
    bc.horizontal = horizontal;
    % look through all the elements
    for i=1:numel(mesh.elements)
        % look through all the x and y for this element
        x = [ mesh.elements(i).global_corner_x' ...
            mesh.elements(i).global_midside_x' ];
        y = [ mesh.elements(i).global_corner_y' ...
            mesh.elements(i).global_midside_y' ];
        % evaluate the criteria for each point, if there is a true then
        % that node is on the boundary and this entire element should be
        % added to the bc elements matrix
        result = feval(criteria,x,y);
        % if there are any trues, then this element should be added to the
        % matrix describing that the element has a bc
        if sum(result)==3
            % put this element number in the bc elements matrix
            bc.elements(j).num = i;
            % container for xi and eta
            xi = [ mesh.elements(i).local_corner_xi mesh.elements(i).local_midside_xi ];
            eta = [ mesh.elements(i).local_corner_eta mesh.elements(i).local_midside_eta ];
            % add the xi values to the bc
            bc.elements(j).xi = xi(result);
            bc.elements(j).eta = eta(result);
            % the locations of the nodes with trues show us which (local) 
            % nodes have bcs
            bc.elements(j).local_nodes = find(result);
            bc.elements(j).x = x(bc.elements(j).local_nodes);
            bc.elements(j).y = y(bc.elements(j).local_nodes);
            bc.x = [ bc.x x(bc.elements(j).local_nodes) ];
            bc.y = [ bc.y y(bc.elements(j).local_nodes) ];
            for k = 1:numel(bc.elements(j).local_nodes)
                bc.elements(j).local_values(k) = ...
                    feval(value,x(bc.elements(j).local_nodes(k)),...
                    y(bc.elements(j).local_nodes(k)));
            end
            % we then need to map this to the global nodes
            global_node_mat = [ mesh.elements(i).global_corner_node_no ...
                mesh.elements(i).global_midside_node_no ];
            bc.elements(j).global_nodes = ...
                global_node_mat(bc.elements(j).local_nodes);
            % determine the xi at all the boundary nodes
            local_xi_mat = [ mesh.elements(i).local_corner_xi ...
                mesh.elements(i).local_midside_xi ];
            bc.elements(j).boundary_xi = local_xi_mat(bc.elements(j).local_nodes);
            % add one more to the size of the bc.elements container
            j = j + 1;
        end
    end
    bc.value = value;
    % Plot this to check that it's okay
    axis([-.6 .6 -.6 .6]);
    % set the current figure to the mesh figure
    % highlight the lines that fit criteria
    plot(bc.x,bc.y,'LineWidth',2,'Marker','none','Color',[182 63 151]/255);
    % place boxes with the value on the figure
    text(sum(bc.x)/numel(bc.x),sum(bc.y)/numel(bc.y),...
        [ '$\overline q=' string '$' ],'Interpreter','LaTeX',...
        'BackgroundColor','white','EdgeColor','black');
    title('Boundary Condition Verification Figure','Interpreter','LaTeX');
    bc.fig = gcf;
end