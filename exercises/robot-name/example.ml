open Core

type robot = {mutable index : int}

let index = ref (-1)

let unique_ids: int array =
  let ids = Array.init (26*26*1000) ~f:Fn.id in
  Array.permute ids;
  ids

let new_robot () =
  index := !index + 1;
  {index = unique_ids.(!index)}

let name r =
  let n = r.index in
  let letters_part = n / 1000 in
  let letter_A = Char.to_int 'A' in
  let first_letter = Char.of_int_exn (letter_A + (letters_part / 26)) in
  let second_letter = Char.of_int_exn (letter_A + (letters_part % 26)) in
  sprintf "%c%c%03d" first_letter second_letter (n % 1000)

let reset r =
  index := !index + 1;
  r.index <- unique_ids.(!index);
