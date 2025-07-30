let classify n = 
  let aliquot = function
    | 1 -> 0
    | n when n > 1 ->
        let rec sum_factors acc factor =
          if factor > n / 2 then acc
          else if n mod factor = 0 then
            sum_factors (acc + factor) (factor + 1)
          else
            sum_factors acc (factor + 1)
        in
        sum_factors 0 1
    | _ -> 0 
  in
  match n with
  | _ when n < 1 -> Error "Classification is only possible for positive integers."
  | n -> 
      let aliquot_sum = aliquot n in
      if aliquot_sum = n then Ok "perfect"
      else if aliquot_sum > n then Ok "abundant"
      else Ok "deficient"