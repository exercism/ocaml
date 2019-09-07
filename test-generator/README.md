## What does it do

The test generator takes canonical-data.json files from the x-common folder, and
uses them to create Ocaml tests.

For each exercise, it requires a template file under the tools/test-generator/templates folder.
The template format is rather ad-hoc, but works for most of the exercises that have
canonical data.

## Building

```
cd tools/test-generator
dune build test_gen.exe --profile=release
```

## Running

```
git clone https://github.com/exercism/problem-specifications.git ../problem-specifications
cd tools/test-generator
dune exec test_gen.exe --profile=release
```

The test generator should be run whenever test canonical data is updated.

You will need the latest version of x-common checked out locally, at the same level as your
ocaml repo. 

Please note: running will overwrite tests in the ocaml/exercises folders (this is the default, there
is a command line option to write the tests to a different folder - run test_gen.native --help).

To run, type test_gen.native at the command line.

If you type git status, you will see test files that have been updated.

Some files can be generated but will look better after hand-editing. An example is the minesweeper exercise,
where a list that is part of the input is better presented in a 2D vertically aligned format. To handle this,
the test generator saves it's files in a folder in your home (~/.xocaml-generated - this can be overridden as 
a command line option). If after generation, the file is unchanged from the saved copy, then the test generator
will not overwrite the test in the repo - so git status will be clean.

## Extending

If you find an exercise that the generator cannot handle, pull requests to extend it are welcome.


