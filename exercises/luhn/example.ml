open Core.Std

let valid s =
  let rec sum_digits r c = function
  | 0 -> r
  | i ->
     let d = c * ((int_of_char s.[i-1]) - 48) in
     sum_digits (r + (d/10) + (d mod 10)) (3-c) (i-1)
  in
  (sum_digits 0 1 (String.length s)) mod 10 = 0
