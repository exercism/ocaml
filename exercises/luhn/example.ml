open Core.Std

let digit character =
  (int_of_char character) - 48

let rec sum_digits s r c = function
  | 0 -> r
  | i ->
    let d = c * (digit s.[i - 1]) in
    sum_digits s (r + (d/10) + (d mod 10)) (3-c) (i-1)

let checksum s =
  (sum_digits s 0 1 (String.length s))

let valid s =
  (checksum s) mod 10 = 0

let add_check_digit s =
  let check = ((sum_digits s 0 2 (String.length s)) mod 10) in
  String.concat ~sep:"" [s; (string_of_int ((10 - check) mod 10))]
