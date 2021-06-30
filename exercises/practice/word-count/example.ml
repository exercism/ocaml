open Base

let add_to_map wcs w =
  Map.update wcs w ~f:(fun k -> Option.value_map k ~default:1 ~f:((+) 1))

let normalize = function
  | ch when Char.is_alphanum ch || Char.equal ch '\'' -> Char.lowercase ch
  | _ -> ' '

type position =
  | Start
  | End

let quote_at s ~pos = 
  let p = match pos with
  | Start -> 0
  | End -> String.length s - 1
  in
  String.is_substring_at s ~pos:p ~substring:"'"

let word_count s =
  let s = String.map s ~f:normalize in
  let split = 
    List.filter (String.split s ~on:' ') ~f:(Fn.non String.is_empty)
    |> List.map ~f:(fun w -> 
      let len = String.length w in
      if len >= 2 && quote_at w ~pos:Start && quote_at w ~pos:End 
      then Caml.String.sub w 1 (len - 2)
      else w)
  in
  List.fold ~init:(Map.empty (module String)) ~f:add_to_map split
