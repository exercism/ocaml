open Core

let check_valid_first_digits s =
  if s.[0] = '0' || s.[0] = '1' || s.[3] = '0' || s.[3] = '1'
  then None
  else Some s

let number s =
  if not @@ String.is_empty (String.filter ~f:(Char.is_alpha) s)
  then None
  else
    let s = String.filter ~f:(Char.is_digit) s in
    match String.length s with
    | 10                            -> check_valid_first_digits s
    | 11 when String.get s 0 = '1'  -> check_valid_first_digits (String.drop_prefix s 1)
    | _                             -> None