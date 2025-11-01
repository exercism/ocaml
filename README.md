# Exercism OCaml Track

Exercism Exercises in OCaml

## Contributing Guide

Contributions to the OCaml track (or any other part of Exercism) are very welcome!

Please see the [contributing guide](https://github.com/exercism/docs/blob/master/contributing-to-language-tracks/README.md) for overall guidance. The below
notes contain a few details specific to Ocaml.

## Getting started

### Local setup

**Prerequisites**

- OCaml `5.4`
- opam
- make

```sh
git clone https://github.com/exercism/ocaml.git
cd ocaml
git submodule update --init --recursive

# see https://github.com/exercism/ocaml/blob/master/.travis/Dockerfile#L12
# might take a while
make install_deps

# Run generator tests
make test_generator

# Execute generator
make generate_exercises

# Run exercise tests
make test
```

<details>
    <summary>Container setup</summary>

**Prerequisites**

- VSCode
- VSCode Remote Containers extension
- Docker

```sh
git clone https://github.com/exercism/ocaml.git
cd ocaml
git submodule update --init --recursive

vscode .

# Inside container

# Run generator tests
make test_generator

# Execute generator
make generate_exercises

# Run exercise tests
make test
```

</details>

## Adding an Exercise

The [contributing guide](https://github.com/exercism/docs/blob/main/building/tracks/README.md) provides guidance on
how to add a new exercise, or port an existing exercise from another language track.

This is a brief guide, with specifics for the OCaml track.

Firstly, register the exercise in [config json](https://exercism.org/docs/building/tracks/config-json). The name of the exercise should go in the "slug" entry.

Then, write the exercise tests and proof of concept implementation.
A folder layout for an exercise called "ocaml-exercise" is below.

```
└── templates
    └── ocaml-exercise
        ├── example.ml.tpl           (a proof of concept implementation)
        ├── ocaml_exercise.mli.tpl   (the interface definition for the exercise)
        ├── HINTS.md.tpl             (additional hints to anyone trying the exercise - optional)
        ├── Makefile                 (standard - copy this from any of the other Ocaml exercises)
        └── test.ml.tpl              (unit tests)
```

You can build your exercises from `templates/ocaml-exercise` to `exercises/ocaml-exercise` via the test generator:

```sh
make generate_exercises
```

This creates a folder `exercises/ocaml-exercises` that mirrors `templates/ocaml-exercises` and strips the `.tpl` extension:

```
└── templates
    └── ocaml-exercise
        ├── example.ml
        ├── ocaml_exercise.mli
        ├── HINTS.md
        ├── Makefile
        └── test.ml
```

## Canonical test data

If you are implementing an existing test, there may be "canonical data" for it in the [problem-specifications](https://github.com/exercism/problem-specifications) repository.
An example: https://github.com/exercism/problem-specifications/blob/4531f54300f2a9f485a91a5dc0228be448b46b97/exercises/hello-world/canonical-data.json#L1-L12

You should base your tests off this data, in order to provide consistency across different language tracks.

## Feedback

If you find this documentation is inaccurate or incomplete, or can be improved in any way, please don't hesitate to raise an [issue](https://github.com/exercism/ocaml/issues) or submit a pull request.

### OCaml icon

The [OCaml](https://ocaml.org) logo is released under the [Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/) license.
