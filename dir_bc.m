function [bc] = dir_bc(mesh,criteria,value,string)
    % initialize the x and y coords for the boundary condition
    bc.x = []; bc.y = [];
    hold on;
    % initialize an element counter
    j=1;
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
        if sum(result) >= 3
            % put this element number in the bc elements matrix
            bc.elements(j).num = i;
            % the locations of the nodes with trues show us which (local) 
            % nodes have bcs
            bc.elements(j).local_nodes = find(result);
            bc.x = [ bc.x x(bc.elements(j).local_nodes) ];
            bc.y = [ bc.y y(bc.elements(j).local_nodes) ];
            xs = x(bc.elements(j).local_nodes);
            ys = y(bc.elements(j).local_nodes);
            if numel(xs) >= 3
                plot(xs([1 3 2]),ys([1 3 2]),...
                    'LineWidth',2,'Marker','none',...
                    'Color',[46 175 164]/255);
            end
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
            % add one more to the size of the bc.elements container
            j = j + 1;
        end
    end
    bc.value = value;
    % Plot this to check that it's okay
    axis([-.6 .6 -.6 .6]);
    % set the current figure to the mesh figure
    % highlight the lines that fit criteria
    
    % place boxes with the value on the figure
    text(sum(bc.x)/numel(bc.x),sum(bc.y)/numel(bc.y),...
        [ '$\overline T=' string '$' ],'Interpreter','LaTeX',...
        'BackgroundColor','white','EdgeColor','black');
    title('Boundary Condition Verification Figure','Interpreter','LaTeX');
    bc.fig = gcf;
end