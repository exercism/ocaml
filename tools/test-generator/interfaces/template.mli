open Core.Std

open Codegen

type t = {start: int; finish: int; file_text: string; template: string}

val fill : int -> int -> template: string -> subst list -> string

val find_template : template_text: string -> (int * int * string) option

val show : t -> string
