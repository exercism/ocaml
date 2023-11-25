
let to_roman n = 
  assert (n < 4000);

  let build ones halves tens = function
    | 0 -> ""
    | 1 -> ones
    | 2 -> ones ^ ones
    | 3 -> ones ^ ones ^ ones
    | 4 -> ones ^ halves
    | 5 -> halves
    | 6 -> halves ^ ones
    | 7 -> halves ^ ones ^ ones
    | 8 -> halves ^ ones ^ ones ^ ones
    | 9 -> ones ^ tens
    | _ -> assert false
  in
  let thousands n = build "M" "" "" (n / 1000 mod 10) in
  let hundreds n  = build "C" "D" "M" (n / 100 mod 10) in
  let tens n      = build "X" "L" "C" (n / 10 mod 10) in
  let ones n      = build "I" "V" "X" (n mod 10) in

  thousands n ^ hundreds n ^ tens n ^ ones n