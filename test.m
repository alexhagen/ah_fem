function test

clc;
% Choose one of the following strings - '*Node', '*Element, type=<element_type>',
% '*Nset, nset=<nameofset>', '*Elset, elset=<nameofset>'

% example

filename = 'example.inp';

% get node matrix
string1 = '*Node';

% nodes - 2D array with 3 columns - node no., x-coordinate, y-coordinate and rows = no. of nodes 
nodes = readinp(string1,filename);

% get element connectivity matrix for element type CPS8R
string2 = '*Element, type=CPS8R';

% elements - 2D array with columns - element no., nodes in element and connectivity and rows = no. of elements 
elements = readinp(string2,filename);

% get nodes for nset=NodeSetName
string3 = '*Nset, nset=NodeSetName';

% nsetbc1 - 1D array of node nnumbers in the set 
nsetbc1 = readinp(string3,filename);

% get elements for elset=ElementSetName
string4 = '*Elset, elset=ElementSetName';

% eletbc1 - 1D array of element numbers in the set 
elsetbc1 = readinp(string4,filename);