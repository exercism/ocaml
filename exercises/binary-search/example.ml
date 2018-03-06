open Base

let find xs value = 
  let rec go lo hi = 
    if lo > hi then None
    else begin 
      let mid = lo + (hi - lo) / 2 in
      let mid_val = xs.(mid) in
      if mid_val < value
      then go (mid + 1) hi
      else if mid_val > value
      then go lo (mid - 1)
      else Some mid
    end
  in
  if Array.is_empty xs
  then None
  else go 0 (Array.length xs - 1) 
  