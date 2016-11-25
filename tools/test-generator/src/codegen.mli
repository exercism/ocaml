open Core.Std

open Model

type fixup_parameter_function = key: string -> value: parameter -> string

type edit_parameters_function = (string * string) list -> (string * string) list

val generate_code : fixup_parameter_function -> edit_parameters_function -> string -> case list -> (string list, string) Result.t
