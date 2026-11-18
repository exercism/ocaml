let validate candidate =
  let rec armstrong ~candidate ~num ~sum =
    if num <= 0 then sum = candidate
    else
      let num_digits = int_of_float (floor (log10 (float_of_int candidate)) +. 1.) in
      let digit = num mod 10 in
      let new_sum = sum + int_of_float (float_of_int digit ** float_of_int num_digits) in
      let new_num = num / 10 in
      armstrong ~candidate ~num:new_num ~sum:new_sum
    in

  match () with
  | _ when candidate < 10 -> true
  | _ when candidate < 100 -> false
  | _ -> armstrong ~candidate ~num:candidate ~sum:0