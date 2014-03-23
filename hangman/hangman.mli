(** Hangman exercise (FRP using the react library)

This exercise requires you to install the [react] library
(using [opam install react]).

If you invoke [ocamlfind] or [corefind] manually be sure to add the
[-use-ocamlfind] and [-package react] flags.
*)
open React

(** Abstract type, make of this what you want. *)
type t

(**
The high level state of the game.

Either the game has been won, the game has been lost or the game is in progress
with N allowed failures left (initially 9).
*)
type progress =
    | Win
    | Lose
    | Busy of int

(**
Create a new game to guess the specified word.
*)
val create : string -> t

(** Feed a letter into the game. *)
val feed : char -> t -> unit

(** 
Get a signal that contains the word to be guessed with all not yet guessed
letters replaced by underscores.
*)
val masked_word : t -> string signal

(**
Get a signal that contains the high level state of the game (won, lost, N
attempts left).
*)
val progress : t -> progress signal
