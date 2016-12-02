open Core.Std
open Yojson.Safe
open Yojson.Safe.Util

let map2 (f: 'a -> 'b -> 'c) (r1: ('a, 'e) Result.t) (r2: ('b, 'e) Result.t): ('c, 'e) Result.t = match (r1, r2) with
  | (Error x, _) -> Error x
  | (_, Error x) -> Error x
  | (Ok a, Ok b) -> Ok (f a b)

let sequence (rs: (('a, 'e) Result.t) list): (('a list), 'e) Result.t =
  List.fold_right rs ~init:(Ok []) ~f:(map2 (fun x xs -> x :: xs))

let to_list_option json =
  try Some (to_list json) with Type_error _ -> None

let to_list_note error json =
  try Ok (to_list json) with Type_error _ -> Error error

let to_assoc_note error json =
  try Ok (to_assoc json) with Type_error _ -> Error error

let to_string_note error json =
  try Ok (to_string json) with Type_error _ -> Error error

let safe_to_int_option json =
  try Some (to_int json) with Type_error _ -> None

let member_note error m json =
  try Ok (member m json) with Type_error _ -> Error error

let (>>) f g = Fn.compose f g

let find_arrayi ?start:(start = 0) xs ~f =
  let rec go i =
    if i >= Array.length xs then None
    else if f xs.(i) then Some (i, xs.(i))
    else go (i + 1) in
  go start
