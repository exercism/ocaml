# Triangle

Determine if a triangle is equilateral, isosceles, or scalene.

An _equilateral_ triangle has all three sides the same length.

An _isosceles_ triangle has at least two sides the same length. (It is sometimes
specified as having exactly two sides the same length, but for the purposes of
this exercise we'll say at least two.)

A _scalene_ triangle has all sides of different lengths.

## Note

For a shape to be a triangle at all, all sides have to be of length > 0, and
the sum of the lengths of any two sides must be greater than or equal to the
length of the third side. See [Triangle Inequality](https://en.wikipedia.org/wiki/Triangle_inequality).

## Dig Deeper

The case where the sum of the lengths of two sides _equals_ that of the
third is known as a _degenerate_ triangle - it has zero area and looks like
a single line. Feel free to add your own code/tests to check for degenerate triangles.

## Getting Started
For installation and learning resources, refer to the
[exercism help page](http://exercism.io/languages/ocaml).

## Installation
To work on the exercises, you will need `Opam` and `Base`. Consult [opam](https://opam.ocaml.org) website for instructions on how to install `opam` for your OS. Once `opam` is installed open a terminal window and run the following command to install base:

```bash
opam install base
```

To run the tests you will need `OUnit`. Install it using `opam`:

```bash
opam install ounit
```

## Running Tests
A Makefile is provided with a default target to compile your solution and run the tests. At the command line, type:

```bash
make
```

## Interactive Shell
`utop` is a command line program which allows you to run Ocaml code interactively. The easiest way to install it is via opam:
```bash
opam install utop
```
Consult [utop](https://github.com/diml/utop/blob/master/README.md) for more detail.

## Feedback, Issues, Pull Requests
The [exercism/ocaml](https://github.com/exercism/ocaml) repository on
GitHub is the home for all of the Ocaml exercises.

If you have feedback about an exercise, or want to help implementing a new
one, head over there and create an issue.  We'll do our best to help you!

## Source

The Ruby Koans triangle project, parts 1 & 2 [http://rubykoans.com](http://rubykoans.com)

## Submitting Incomplete Solutions
It's possible to submit an incomplete solution so you can see how others have completed the exercise.
