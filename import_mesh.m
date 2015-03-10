function [mesh]=import_mesh(filename)
    % import full node matrix
    nodes = readinp('*Node',filename);
    % find number of nodes
    mesh.n_nodes = size(nodes,1);
    % import full element matrix
    elements_local = readinp('*Element',filename);
    % find number of elements
    mesh.n_el = size(elements_local,1);
    % preallocate the elements structure array
    element = struct('el_no',0,'el_type','','local_corner_xi',zeros(1,4),...
        'local_corner_eta',zeros(1,4),'local_midside_xi',zeros(1,4),...
        'local_midside_eta',zeros(1,4),'global_corner_node_no',zeros(1,4),...
        'global_midside_node_no',zeros(1,4),'global_corner_x',zeros(1,4),...
        'global_corner_y',zeros(1,4),'global_midside_x',zeros(1,4),...
        'global_midside_y',zeros(1,4));
    elements = repmat(element,1,mesh.n_el);
    % construct mesh
    for i = 1:size(elements_local,1)
        % find element number
        elements(i).el_no = elements_local(i,1);
        % determine if quad or tri element
        if size(elements_local,2)-1 == 6
            elements(i).el_type = 'quadratic triangular';
            elements(i).local_corner_xi = [1 0 0 ];
            elements(i).local_corner_eta = [0 1 0];
            elements(i).local_midside_xi = [0.5 0 0.5];
            elements(i).local_midside_eta = [0.5 0.5 0];
            elements(i).n_nodes = 6;
            el_no_corners = 3;
        elseif size(elements_local,2)-1 == 8
            elements(i).el_type = 'quadratic quadrilateral';
            el_no_corners = 4;
            elements(i).local_corner_xi = [-1,1,1,-1];
            elements(i).local_corner_eta = [-1,-1,1,1];
            elements(i).local_midside_xi = [0,1,0,-1];
            elements(i).local_midside_eta = [-1,0,1,0];
            elements(i).n_nodes = 8;
        end
        % preallocate the array for the element corners and midside nodes
        elements(i).global_corner_node_no = zeros(1,el_no_corners);
        elements(i).global_midside_node_no = zeros(1,el_no_corners);
        elements(i).global_corner_x = zeros(1,el_no_corners);
        elements(i).global_corner_y = zeros(1,el_no_corners);
        elements(i).global_midside_x = zeros(1,el_no_corners);
        elements(i).global_midside_y = zeros(1,el_no_corners);
        % add the node values
        elements(i).global_corner_node_no = elements_local(i,2:1+el_no_corners);
        elements(i).global_midside_node_no = elements_local(i,2+el_no_corners:end);
        % add the global x values
        elements(i).global_corner_x = nodes(elements(i).global_corner_node_no,2);
        elements(i).global_midside_x = nodes(elements(i).global_midside_node_no,2);
        % add the global y values
        elements(i).global_corner_y = nodes(elements(i).global_corner_node_no,3);
        elements(i).global_midside_y = nodes(elements(i).global_midside_node_no,3);
        mesh.elements = elements;
        %plot this to make sure it's right
        mesh.fig = subplot(2,2,1);
        hold on;
        patch(elements(i).global_corner_x,...
            elements(i).global_corner_y,...
            ones(size(elements(i).global_corner_y)),...
            'FaceColor',[227 174 36]/255);
        plot(elements(i).global_corner_x,...
            elements(i).global_corner_y,'kx');
        plot(elements(i).global_midside_x,...
            elements(i).global_midside_y,'kx');
        xlabel('x-coordinate ($x$) [$mm$]','Interpreter','LaTeX');
        ylabel('y-coordinate ($y$) [$mm$]','Interpreter','LaTeX');
        title('Mesh Verification Figure','Interpreter','LaTeX');
        axis([-.6 .6 -.6 .6]);
    end