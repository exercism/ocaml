open Core.Std

type parameter =
  | String of string
  | Float of float
  | Int of int
  | Bool of bool [@@deriving eq, show]

type 'a elements = (string * 'a) list [@@deriving eq, show]

type case = {
  name: string;
  parameters: parameter elements;
  expected: parameter;
} [@@deriving eq, show]

let parameter_to_string = function
  | String s -> s
  | Float f -> Float.to_string f
  | Int n -> Int.to_string n
  | Bool b -> Bool.to_string b
