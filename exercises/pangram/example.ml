open Base

exception Finished of int

let is_pangram s = 
  let alphabet_bits = (1 lsl 26) - 1 in
  let update_bits return b ch =  
    let updated = 
      if Char.is_alpha ch 
      then b lor (1 lsl (Char.to_int (Char.uppercase ch) - Char.to_int 'A'))
      else b in 
    if updated = alphabet_bits then return alphabet_bits else updated
  in
  let return s = raise (Finished s) in
  try
    String.fold s ~init:0 ~f:(update_bits return) = alphabet_bits
  with
    Finished s -> Int.(s = alphabet_bits)