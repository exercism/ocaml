open Core.Std

open Model

type fixup_function = key: string -> value: parameter -> string

val generate_code : fixup_function -> string -> case list -> (string list, string) Result.t
