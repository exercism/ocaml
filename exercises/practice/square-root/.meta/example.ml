let square_root n =
  let radicand = float_of_int n in
  let rec aux guess =
    let next = 0.5 *. (guess +. radicand /. guess) in
    match abs_float (next -. guess) with
    | diff when diff < 0.0001 -> int_of_float next
    | _ -> aux next
  in
  if n < 0 then invalid_arg "square_root: negative input"
  else aux (radicand /. 2.0)
