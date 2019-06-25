# Minesweeper

Add the numbers to a minesweeper board.

Minesweeper is a popular game where the user has to find the mines using
numeric hints that indicate how many mines are directly adjacent
(horizontally, vertically, diagonally) to a square.

In this exercise you have to create some code that counts the number of
mines adjacent to a square and transforms boards like this (where `*`
indicates a mine):

    +-----+
    | * * |
    |  *  |
    |  *  |
    |     |
    +-----+

into this:

    +-----+
    |1*3*1|
    |13*31|
    | 2*2 |
    | 111 |
    +-----+


## Getting Started
1. [Install the Exercism CLI](https://exercism.io/cli-walkthrough).

2. [Install OCaml](https://exercism.io/tracks/ocaml/installation).

3. For library documentation, follow [Useful OCaml resources](https://exercism.io/tracks/ocaml/resources).

## Running Tests
A `Makefile` is provided with a default target to compile your solution and run the tests. At the command line, type:

```bash
make
```

## Submitting Incomplete Solutions
It's possible to submit an incomplete solution so you can see how others have completed the exercise.

## Feedback, Issues, Pull Requests
The [exercism/ocaml](https://github.com/exercism/ocaml) repository on GitHub is
the home for all of the Ocaml exercises.

If you have feedback about an exercise, or want to help implementing a new
one, head over there and create an issue or submit a PR. We welcome new
contributors!

