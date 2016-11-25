open Core.Std

open Model

val default_value : key: string -> value: string -> (string * string) list -> (string * string) list

val optional_int : none: int -> parameter -> string

val optional_string : f: (string -> bool) -> (string * string) list -> (string * string) list

val fixup : stringify:(parameter -> string) -> slug:string -> key:string -> value:parameter -> string

val edit : slug: string -> (string * string) list -> (string * string) list
