# AH_FEM
A Finite Element Code written by Alex Hagen

**this code is incomplete and will be updated as written.  To see a complete but unverified FEM code I've written, look in the branch `matlab_linear` and `matlab_nonlinear`.**

## Outline

1. Introduction and Motivation
2. Capabilities
3. Usage
4. Installation
5. To-Do

## 1. Introduction and Motivation

## 2. Capabilities

## 3. Usage

I have strived to make `ah_fem` free from issues with compatibility and easy to use.  An example of the usage of ah_fem follows the object-oriented type compilation input for codes like COMSOL or Elmer.  An example lies below

```python

# import a cad file
block = new geometry('/path/to/file.stl');

# define mesh settings
tetblock = new mesh(geometry=block,generation='no');
tetblock.set_type('tetrahedral');
tetblock.set_size('0.1 mm');

# add material or material properties
copper = new material();
copper.set('k','1 W/mK');

# apply material to the geometry
tetblock.set_material(copper);

# choose an equation
poisson = new equation('poisson');

# define boundary conditions
tetblock.set_bc('x == 0','q = 5 W');

# generate the mesh
tetblock.generate();

# solve the problem
conductivity_problem = new solver();
conductivity_problem.set_mesh(tetblock);
conductivity_problem.set_equation(poisson);
conductivity_problem.solve();

```

## 4. Installation

## 5. To-Do

- [ ] Find a CAD package with ascii output that I can import for the geometry
- [ ] Write or use a meshing script
- [ ] Write a class to bring in numbers as strings with units and also significant figures
- [ ] Write the rest of the FEM codes