# Roman Numerals

Write a function to convert from normal numbers to Roman Numerals.

The Romans were a clever bunch. They conquered most of Europe and ruled
it for hundreds of years. They invented concrete and straight roads and
even bikinis. One thing they never discovered though was the number
zero. This made writing and dating extensive histories of their exploits
slightly more challenging, but the system of numbers they came up with
is still in use today. For example the BBC uses Roman numerals to date
their programmes.

The Romans wrote numbers using letters - I, V, X, L, C, D, M. (notice
these letters have lots of straight lines and are hence easy to hack
into stone tablets).

```text
 1  => I
10  => X
 7  => VII
```

There is no need to be able to convert numbers larger than about 3000.
(The Romans themselves didn't tend to go any higher)

Wikipedia says: Modern Roman numerals ... are written by expressing each
digit separately starting with the left most digit and skipping any
digit with a value of zero.

To see this in practice, consider the example of 1990.

In Roman numerals 1990 is MCMXC:

1000=M
900=CM
90=XC

2008 is written as MMVIII:

2000=MM
8=VIII

See also: http://www.novaroma.org/via_romana/numbers.html


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

## Source

The Roman Numeral Kata [http://codingdojo.org/cgi-bin/index.pl?KataRomanNumerals](http://codingdojo.org/cgi-bin/index.pl?KataRomanNumerals)

