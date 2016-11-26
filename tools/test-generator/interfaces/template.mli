open Core.Std

type t = {start: int; finish: int; file_text: string; template: string}

val splice_in_filled_in_code : int -> int -> template: string -> string list -> string

val find_template : template_text: string -> (int * int * string) option

val show : t -> string
