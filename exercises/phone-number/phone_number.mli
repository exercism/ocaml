open Base

(** Extract the digits from a valid phone number. *)
val number : string -> (string, string) Result.t 