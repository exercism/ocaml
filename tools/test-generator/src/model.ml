open Core.Std

type 'a elements = (string * 'a) list [@@deriving eq, show]

type expected =
  | String of string
  | Float of float
  | Bool of bool [@@deriving eq, show]

type case = {
  name: string;
  int_assoc: int elements;
  expected: expected;
} [@@deriving eq, show]

let print_expected = function
  | String s -> s
  | Float f -> Float.to_string f
  | Bool b -> Bool.to_string b
