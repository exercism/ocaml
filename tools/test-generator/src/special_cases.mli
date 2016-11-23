open Core.Std

open Model

val optional_int : none: int -> parameter -> string

val fixup : stringify:(parameter -> string) -> slug:string -> key:string -> value:parameter -> string
