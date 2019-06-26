open Base
open Yojson.Basic
open Yojson.Basic.Util

let map2 (f: 'a -> 'b -> 'c) (r1: ('a, 'e) Result.t) (r2: ('b, 'e) Result.t): ('c, 'e) Result.t = match (r1, r2) with
  | (Error x, _) -> Error x
  | (_, Error x) -> Error x
  | (Ok a, Ok b) -> Ok (f a b)

let map2_option (f: 'a -> 'b -> 'c) (r1: 'a option) (r2: 'b option): 'c option = match (r1, r2) with
  | (None, _) -> None
  | (_, None) -> None
  | (Some a, Some b) -> Some (f a b)

let sequence (rs: (('a, 'e) Result.t) list): (('a list), 'e) Result.t =
  List.fold_right rs ~init:(Ok []) ~f:(map2 (fun x xs -> x :: xs))

let sequence_option (rs: ('a option) list): ('a list) option =
  List.fold_right rs ~init:(Some []) ~f:(map2_option (fun x xs -> x :: xs))

let to_list_option json =
  try Some (to_list json) with Type_error _ -> None

let to_list_note error json =
  try Ok (to_list json) with Type_error _ -> Error error

let to_assoc_note error json =
  try Ok (to_assoc json) with Type_error _ -> Error error

let to_assoc_option json =
  try Some (to_assoc json) with Type_error _ -> None

let to_string_note error json =
  try Ok (to_string json) with Type_error _ -> Error error

let to_string_option json =
  try Some (to_string json) with _ -> None

let safe_to_int_option json =
  try Some (to_int json) with Type_error _ -> None

let member_note error m json =
  try Ok (member m json) with Type_error _ -> Error error

let find_note (xs: (string, 'b) List.Assoc.t) (key: string) (error: 'e): ('b, 'e) Result.t = 
  match List.Assoc.find ~equal:(String.equal) xs key with
  | Some v -> Ok v
  | None -> Error error

let (>>) f g = Fn.compose f g

let find_arrayi ?start:(start = 0) xs ~f =
  let rec go i =
    if i >= Array.length xs then None
    else if f xs.(i) then Some (i, xs.(i))
    else go (i + 1) in
  go start

let file_exists dir =
  try Unix.access dir [Unix.F_OK]; true
  with Unix.Unix_error _ -> false

let is_directory dir =
  let s = Unix.stat dir in
  phys_equal s.st_kind Unix.S_DIR

let ls_dir dir =
  let handle = Unix.opendir dir in
  let result = ref [] in
  let push i = result := !result @ [i] in
  try 
    while true do
      push (Unix.readdir handle)
    done;
    !result
  with _ -> 
    Unix.closedir handle;
    !result
