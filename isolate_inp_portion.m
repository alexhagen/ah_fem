function string = isolate_inp_portion(startstr,filename)
    % read the whole file to string
    filestr = fileread(filename);
    % find the first instance of the start expression, or none
    [start,~] = regexp(filestr,['(\*\*\s' startstr ')']);
    % if there is one, find the entire section
    if ~isempty(start)
        string = filestr(start(1):end);
        [stop,~] = regexp(string,'(\*\*\s[A-Z][A-Z])');
        string = string(1:stop(2));
    else
    % if there isnt one, return an empty string
        string = '';
    end
end