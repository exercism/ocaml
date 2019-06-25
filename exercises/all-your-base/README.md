# All Your Base

Convert a number, represented as a sequence of digits in one base, to any other base.

Implement general base conversion. Given a number in base **a**,
represented as a sequence of digits, convert it to base **b**.

## Note

- Try to implement the conversion yourself.
  Do not use something else to perform the conversion for you.

## About [Positional Notation](https://en.wikipedia.org/wiki/Positional_notation)

In positional notation, a number in base **b** can be understood as a linear
combination of powers of **b**.

The number 42, *in base 10*, means:

(4 * 10^1) + (2 * 10^0)

The number 101010, *in base 2*, means:

(1 * 2^5) + (0 * 2^4) + (1 * 2^3) + (0 * 2^2) + (1 * 2^1) + (0 * 2^0)

The number 1120, *in base 3*, means:

(1 * 3^3) + (1 * 3^2) + (2 * 3^1) + (0 * 3^0)

I think you got the idea!

*Yes. Those three numbers above are exactly the same. Congratulations!*


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

