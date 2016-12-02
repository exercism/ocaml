open Core.Std

open Model

val edit_expected : stringify:(parameter -> string) -> slug:string -> key:string -> value:parameter -> string

val edit_parameters : slug: string -> (string * string) list -> (string * string) list
