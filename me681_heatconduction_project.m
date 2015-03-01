%-------------------------------------------------------------------------%
%                ME 681 Finite and Boundary Element Methods               %
%                        Project function template                        %
%                                                                         %
% Note: 1) Use this function as a starting point for your code            %
%       2) Make sure all other functions that you need to run your code   %
%          are called from here. When the code is tested only this        %
%          function will be run.                                          %
%-------------------------------------------------------------------------%

function me681_heatconduction_project()
    %%% change this and add your name 
    %%% replace any spaces , dots in  your name with an underscore 
    %%% John Doe becomes John_Doe
    disp('This project was done by')
    student_name = 'your name here';
    disp(student_name)
    
    %%% Creates a directory with your name .
    if (~exist(student_name,'dir'))
       % Command under Window
       system(['md', student_name]);
       % Command under MacOS
       % system(['mkdir ',student_name]);
    end
    
    %%% the rest of your code for the code evaluation part goes 
    %%% here. 
    %%% Make sure things are commented. 
    
    
    
    
    
    %%% Make sure that any figures that your code outputs are saved to your directory    
    %%% For example, prob1_temperature.png should be saved to
    %%% 'student_name/prob1_temperature.png'
    
end