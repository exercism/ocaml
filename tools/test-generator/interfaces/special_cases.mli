open Core.Std

open Model

val fixup : stringify:(parameter -> string) -> slug:string -> key:string -> value:parameter -> string

val edit : slug: string -> (string * string) list -> (string * string) list
