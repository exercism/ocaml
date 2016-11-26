open Core.Std

open Model

type fixup_parameter_function = key: string -> value: parameter -> string

type edit_parameters_function = (string * string) list -> (string * string) list

type subst = Subst of string

val subst_to_string : subst -> string

val generate_code : fixup_parameter_function -> edit_parameters_function -> string -> case list -> (subst list, string) Result.t
