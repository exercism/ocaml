let nth_prime n =
  if n <= 0 then
    Error "there is no zeroth prime"
  else
    let is_prime x =
      let rec aux d =
        d * d > x || (x mod d <> 0 && aux (d + 1))
      in
      aux 2
    in
    let rec find count candidate =
      if count = n then Ok (candidate - 1)
      else if is_prime candidate then
        find (count + 1) (candidate + 1)
      else
        find count (candidate + 1)
    in
    find 0 2
