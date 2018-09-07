# Nucleotide Count

Given a single-stranded DNA string, compute how many times each nucleotide
occurs in the string.

The genetic language of every living thing on the planet is DNA.  DNA is a
large molecule that is built from an extremely long sequence of individual
elements called nucleotides.  Four types exist in DNA and these differ only
slightly and can be represented as the following symbols:

- `'A'` for Adenine,
- `'C'` for Cytosine,
- `'G'` for Guanine, and
- `'T'` for Thymine.

Since not all `char` are valid nucleotides and not all `string` are valid
DNA strings, part of this exercise is to only give a result for meaningful
input. See [Real World Ocaml Chapter 7. Error Handling][rwo7] for more
information.

[rwo7]: https://v1.realworldocaml.org/v1/en/html/error-handling.html

The exercise consists of three parts:
- Given an input character, determine if it `is_nucleotide`.
- Given an input DNA string and a nucleotide, count the number of times the
  nucleotide occurs in the string.  If the nucleotide `c` is invalid, or the
  DNA string contains an invalid nucleotide `c`, the result should be `Error c`.
- Given an input DNA string, count all the nucleotides in the string and
  gather the result in a `Char.Map`.  If the DNA string contains an invalid
  nucleotide `c`, the result should be `Error c`.  Otherwise the result
  should be `Ok map`.

See `test.ml` for examples.

## Getting Started
For installation and learning resources, refer to the
[exercism help page](http://exercism.io/languages/ocaml).

## Installation
To work on the exercises, you will need `Opam` and `Core`. Consult [opam](https://opam.ocaml.org) website for instructions on how to install `opam` for your OS. Once `opam` is installed open a terminal window and run the following command to install core:

```bash
opam install core
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

The Calculating DNA Nucleotides_problem at Rosalind [http://rosalind.info/problems/dna/](http://rosalind.info/problems/dna/)

## Submitting Incomplete Solutions
It's possible to submit an incomplete solution so you can see how others have completed the exercise.
