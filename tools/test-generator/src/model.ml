open Core.Std

open Utils

type parameter =
  | String of string
  | Float of float
  | Int of int
  | Bool of bool
  | StringList of (string list) [@@deriving eq, show]

type 'a elements = (string * 'a) list [@@deriving eq, show]

type case = {
  name: string;
  parameters: parameter elements;
  expected: parameter;
} [@@deriving eq, show]

let surround (ch: char) (s: string): string =
  Char.to_string ch ^ s ^ Char.to_string ch

let parameter_to_string = function
  | String s -> String.escaped s
  | Float f -> Float.to_string f
  | Int n -> Int.to_string n
  | Bool b -> Bool.to_string b
  | StringList xs -> "[" ^ String.concat ~sep:"; " (List.map ~f:(surround '\"' >> String.escaped) xs) ^ "]"
