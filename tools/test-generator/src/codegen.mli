open Core.Std

open Model

val generate_code : string -> case list -> (string list, string) Result.t
