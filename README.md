# ah_fem: A finite element code for the solution of Steady State Heat Conduction
Alex Hagen

## Contents

1.  Introduction
2.  Usage
3.  Discussion and Report
4.  Improvement and To-Do

## Introduction

### Motivation

This code, in its MATLAB form and particular meshes, is developed as a deliverable for a Purdue ME 681 Project.  Past that, though, this code is developed to solve the heat conduction equation in two dimensions.  It uses an 8 noded quadrilateral serendipity to solve with several different geometric setups.  To develop these meshes, ABAQUS is used to create input files, and a MATLAB routine is used to solve for the temperature throughout the defined geometry.

### Tasks

- Solve one dimensionally
- Solve two dimensionally
- Solve two dimensionally with a hole inside a square region.

## Usage

Follow the below steps to use the code:

-

```matlab

x = [ 5 5 5 5 ];
```

## Discussion and Report

Discussion can be found in [link](something)

## Improvement and To-Do

- [ ] Port to Python to allow for open-source development
- [ ] continued to-dos