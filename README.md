[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.com/PetrKryslUCSD/FinEtoolsDeforLinearTutorials.jl.svg?branch=master)](https://travis-ci.com/PetrKryslUCSD/FinEtoolsDeforLinearTutorials.jl)
[![Latest documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://petrkryslucsd.github.io/FinEtoolsDeforLinearTutorials.jl/dev)

# FinEtoolsDeforLinearTutorials: Linear stress analysis tutorials


[`FinEtools`](https://github.com/PetrKryslUCSD/FinEtools.jl.git) is a package
for basic operations on finite element meshes. [`FinEtoolsDeforLinear`](https://github.com/PetrKryslUCSD/FinEtoolsDeforLinear.jl.git) is a
package using `FinEtools` to solve linear stress analysis problems. This package provides tutorials for  [`FinEtoolsDeforLinear`](https://github.com/PetrKryslUCSD/FinEtoolsDeforLinear.jl.git).

## News

- 08/20/2020: Created.

## Table of contents

[List of tutorials](docs/src/tutorials/tutorials.md). One can use "Markdown preview"
in VS Code for navigation.

## How to work with the tutorials

Clone the repo:
```
$ git clone https://github.com/PetrKryslUCSD/FinEtoolsDeforLinearTutorials.jl.git
```
Change your working directory into the resulting folder, and run Julia:
```
$ cd FinEtoolsDeforLinearTutorials.jl/
$ julia.exe
```
Activate and instantiate the environment:
```
(v1.5) pkg> activate .; instantiate
```
The tutorial source files are located in the `src` folder.
Locate the one you want, loaded in your IDE or editor of preference, and execute away.

