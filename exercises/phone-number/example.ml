open Core.Std

let number s =
  if not @@ String.is_empty (String.filter ~f:(Char.is_alpha) s)
  then None
  else
    let s = String.filter ~f:(Char.is_digit) s in
    match String.length s with
    | 10                            -> Some s
    | 11 when String.get s 0 = '1'  -> Some (String.drop_prefix s 1)
    | _                             -> None