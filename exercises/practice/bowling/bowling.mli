open Base

(** Abstract type for the bowling game. *)
type t

(** A new bowling game *)
val new_game: t

(** This is called each time the player rolls a ball, with input the number
of pins knocked down. The return value is the updated state of the game. *)
val roll : int -> t -> (t, string) Result.t

(** This is called at the end of a game to retrieve the final score. *)
val score : t -> (int, string) Result.t
