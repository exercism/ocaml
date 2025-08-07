
open Base

let check_valid_first_digits s =
  if Char.(s.[0] = '0') then 
    Error "area code cannot start with zero"
  else if Char.(s.[0] = '1') then
    Error "area code cannot start with one"
  else if Char.(s.[3] = '0') then 
    Error "exchange code cannot start with zero"
  else if Char.(s.[3] = '1') then
    Error "exchange code cannot start with one"
  else Ok s

let is_punctuation = function
  | '@' -> true 
  | '!' -> true
  | _ -> false

let number s =
  if not @@ String.is_empty (String.filter ~f:(Char.is_alpha) s) then 
    Error "letters not permitted"
  else if not @@ String.is_empty (String.filter ~f:(is_punctuation) s) then
    Error "punctuations not permitted"
  else
    let s = String.filter ~f:(Char.is_digit) s in
    match String.length s with
    | x when x < 10                        -> Error "must not be fewer than 10 digits"
    | 10                                   -> check_valid_first_digits s
    | 11 when Char.(String.get s 0 = '1')  -> check_valid_first_digits (String.drop_prefix s 1)
    | 11                                   -> Error "11 digits must start with 1"
    | x when x > 11                        -> Error "must not be greater than 11 digits"
| _ -> Error "incorrect number of digits"