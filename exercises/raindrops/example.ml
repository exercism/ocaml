open Core

let raindrop = function
  | n when n mod 105 = 0 -> "PlingPlangPlong"
  | n when n mod 35 = 0 -> "PlangPlong"
  | n when n mod 21 = 0 -> "PlingPlong"
  | n when n mod 15 = 0 -> "PlingPlang"
  | n when n mod 7 = 0 -> "Plong"
  | n when n mod 5 = 0 -> "Plang"
  | n when n mod 3 = 0 -> "Pling"
  | n -> string_of_int n
