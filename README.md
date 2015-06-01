<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [ ['$','$'], ['\\(','\\)'] ],
  },
  "HTML-CSS": {
    linebreaks: { 
      automatic: true,
      width: "80% container", 
    }
  },
  SVG: { 
    linebreaks: { 
      automatic: true,
      width: "80% container", 
    } 
  },
  TeX: {
    equationNumbers: {
      autoNumber: "all"
    },
  },
    showMathMenu: false
});

</script>

<script type="text/javascript"
     src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

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

### Geometry Input

One of the biggest struggles in quick turnaround finite element modeling is the geometry itself.  Notable examples of difficult to use CAD interfaces within commercial FEM/other physics based modeling packages are COMSOL, and MCNP.  To counteract this, I am going to use two open-source and ASCII formats.  For 2-d geometry, `.svg` files will be used.  These files will be stripped down to only lines and fills, which will define where the solid and boundaries are.  For 3-d geometry, `.x3d` files will be used.  These two file formats also make it especially easy to visualize the input (and, I guess, later, the output).

For the svg import, I'm taking advantage of the wonderful svg.path library.  This allows for the import of path segments straight into geometry points.  I can also use this library to interpolate along the line, which gives me my ability to change the coarseness of the mesh with the *h* parameter.  In the future, I hope to be able to change the mesh coarseness along individual lines, not just on one path segement itself.

## 2. Capabilities

## 3. Usage

I have strived to make `ah_fem` free from issues with compatibility and easy to use.  An example of the usage of ah_fem follows the object-oriented type compilation input for codes like COMSOL or Elmer.  An example lies below

```python

# import a cad file
block = new geometry('/path/to/file.svg'); # we use svg files for 2d geometry
block = new geometry('/path/to/file.x3d'); # we use x3d files for 3d geometry

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

- [x] Find a CAD package with ascii output that I can import for the geometry
- [ ] Write or use a meshing script
- [ ] Write a class to bring in numbers as strings with units and also significant figures
- [ ] Write the rest of the FEM codes