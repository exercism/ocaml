open Core.Std

open Utils
open Yojson.Basic

type parameter =
  | Null
  | String of string
  | Float of float
  | Int of int
  | Bool of bool
  | StringList of (string list)
  | IntList of (int list)
  | IntTupleList of ((int * int) list)
  | IntStringMap of ((string * int) list) [@@deriving eq, show]

type 'a elements = (string * 'a) list [@@deriving eq, show]

(*let pp_json (fmt: Format.formatter) (j: json): unit = *)
  (*fmt.*)

type case = {
  description: string;
  parameters: (string * json) list [@printer fun fmt kjs -> ()];
  expected: json [@printer fun fmt j -> ()];
} [@@deriving show]

type test = {name: string; cases: case list} [@@deriving show]

type tests =
  | Single of case list
  | Suite of test list

let surround (ch: char) (s: string): string =
  Char.to_string ch ^ s ^ Char.to_string ch

let parameter_to_string = function
  | Null -> "null"
  | String s -> String.escaped s
  | Float f -> Float.to_string f
  | Int n -> Int.to_string n
  | Bool b -> Bool.to_string b
  | StringList xs -> "[" ^ String.concat ~sep:"; " (List.map ~f:(surround '\"' >> String.escaped) xs) ^ "]"
  | IntList xs -> "[" ^ String.concat ~sep:"; " (List.map ~f:Int.to_string xs) ^ "]"
  | IntTupleList xs -> "[" ^ String.concat ~sep:"; " (List.map xs ~f:(fun (x,y) -> sprintf "(%d,%d)" x y)) ^ "]"
  | IntStringMap xs -> "[" ^ String.concat ~sep:"; "
                         (List.map xs ~f:(fun (k,v) -> "(\"" ^ String.escaped k ^ "\", " ^ Int.to_string v ^ ")")) ^ "]"

let rec json_to_string (j: json): string = match j with
  | `Null -> "null"
  | `String s -> "\"" ^ (String.escaped s) ^ "\""
  | `Float f -> Float.to_string f
  | `Int n -> Int.to_string n
  | `Bool b -> Bool.to_string b
  | `List xs -> "[" ^ String.concat ~sep:"; " (List.map ~f:json_to_string xs) ^ "]"
  | `Assoc xs -> "[" ^ String.concat ~sep:"; "
                         (List.map xs ~f:(fun (k,v) -> "(\"" ^ String.escaped k ^ "\", " ^ json_to_string v ^ ")")) ^ "]"
