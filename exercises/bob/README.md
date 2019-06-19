# Bob

Bob is a lackadaisical teenager. In conversation, his responses are very limited.

Bob answers 'Sure.' if you ask him a question.

He answers 'Whoa, chill out!' if you yell at him.

He answers 'Calm down, I know what I'm doing!' if you yell a question at him.

He says 'Fine. Be that way!' if you address him without actually saying
anything.

He answers 'Whatever.' to anything else.

Bob's conversational partner is a purist when it comes to written communication and always follows normal rules regarding sentence punctuation in English.

## Error: No implementations provided for the following modules:
         Str referenced from bob.cmx

### Message
```
+ ocamlfind ocamlopt -linkpkg -g -thread -package oUnit -package core bob.cmx test.cmx -o test.native
File "_none_", line 1:
Error: No implementations provided for the following modules:
         Str referenced from bob.cmx
Command exited with code 2.
```

### Reason
You are using a module in your solution, in this case the `Str` module, and the
OCaml build tool is not aware of this.

### Solution
Add the module you are trying to use to the `ocamlbuild` build options.

Modify the `test.native` directive of the Makefile to be:

```
test.native: *.ml *.mli
    @corebuild -quiet -pkg oUnit -pkg str test.native
```

Note the additional `-pkg str` option.



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

Inspired by the 'Deaf Grandma' exercise in Chris Pine's Learn to Program tutorial. [http://pine.fm/LearnToProgram/?Chapter=06](http://pine.fm/LearnToProgram/?Chapter=06)

