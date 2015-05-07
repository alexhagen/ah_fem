function [source] = bf(mesh,value,string)
    source.value = value;
    % Plot this to check that it's okay
    axis([-.6 .6 -.6 .6]);
    % set the current figure to the mesh figure
    % place boxes with the value on the figure
    text(0.25,0.25,...
        [ '$s=' string '$' ],'Interpreter','LaTeX',...
        'BackgroundColor','white','EdgeColor','black');
    title('Boundary Condition Verification Figure','Interpreter','LaTeX');
    source.fig = gcf;
end