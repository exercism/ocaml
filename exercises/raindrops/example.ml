open Core.Std

let raindrop n =
  match n with
  | _ when n mod 105 = 0 -> "PlingPlangPlong"
  | _ when n mod 35 = 0 -> "PlangPlong"
  | _ when n mod 21 = 0 -> "PlingPlong"
  | _ when n mod 15 = 0 -> "PlingPlang"
  | _ when n mod 7 = 0 -> "Plong"
  | _ when n mod 5 = 0 -> "Plang"
  | _ when n mod 3 = 0 -> "Pling"
  | _ -> string_of_int n
