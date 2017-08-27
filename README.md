# xOCaml

Exercism Exercises in OCaml

## Contributing Guide

Contributions to the OCaml track (or any other part of Exercism) are very welcome!

Please see the [contributing guide](https://github.com/exercism/docs/blob/master/contributing-to-language-tracks/README.md) for overall guidance. The below
notes contain a few details specific to Ocaml.

## Prerequisites

The OCaml track assumes installation of OCaml version 4.05.0, and installation of Core, OUnit, and React (for the Hangman exercise).
Assuming you have opam, these can be installed with
```bash
opam install core ounit react
```

## Running Tests

To run all the tests, type `make` from the top level ocaml directory.

To run tests for an individual exercise, `make test-assignment ASSIGNMENT=luhn`

## Adding an Exercise

The [contributing guide](https://github.com/exercism/docs/blob/master/contributing-to-language-tracks/README.md) provides guidance on
how to add a new exercise, or port an existing exercise from another language track. This is a brief guide, with specifics for the OCaml stream.

Firstly, register the exercise in [config json](https://github.com/exercism/docs/blob/master/contributing-to-language-tracks/README.md#configjson). The name of the exercise should go in the "slug" entry.

Then, write the exercise tests & proof of concept implementation.
A folder layout for an exercise called "ocaml-exercise" is below.

```
└── exercises
    └── ocaml-exercise
        ├── .merlin (provided IDE assistance - copy this from any of the other Ocaml exercises)
        ├── example.ml (a proof of concept implementation)
        ├── ocaml_exercise.mli (the interface definition for the exercise)
        ├── HINTS.md (additional hints to anyone trying the exercise - optional)
        ├── Makefile (standard - copy this from any of the other Ocaml exercises)
        ├── test.ml (unit tests)
```
In this example, the Makefile would look for an implementation in ocaml_exercise.ml - as it matches the .mli file name. When developing it is easier to create and edit ocaml_exercise.ml, but the code should be copied to example.ml prior to submitting a pull request (and ocaml_exercise.ml should not be submitted).  

All pull requests are run through a Travis CI build, which compiles and runs tests.

## Canonical test data

If you are implementing an existing test, there may be "canonical data" for it in the [x-common](https://github.com/exercism/x-common) repository.
An example: https://github.com/exercism/x-common/blob/master/exercises/bracket-push/canonical-data.json

You should base your tests off this data, in order to provide consistency across different language tracks.

There is a test generator which can create test code from these json files and an OCaml template file that you 
would need to create. It is a work in progress, so may not work for every exercise. If you wish to use it, there
is documentation [here](tools/test-generator/README.md).

## Feedback

If you find this documentation is inaccurate or incomplete, or can be improved in any way, please don't hesitate to raise an [issue](https://github.com/exercism/ocaml/issues) or submit a pull request.


### OCaml icon
The [OCaml](https://ocaml.org) logo is released under the [Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
