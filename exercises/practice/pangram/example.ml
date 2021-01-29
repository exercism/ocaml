open Base
open Base.Continue_or_stop

let set_alpha b c =
  let i = Char.to_int (Char.uppercase c) - Char.to_int 'A'
  in b lor (1 lsl i)

let add_alpha b c =
  if Char.is_alpha c
  then set_alpha b c
  else b

let got_all_letters =
  let alphabet = 1 lsl 26 - 1 in
  Int.equal alphabet

let is_pangram =
  String.fold_until
    ~init:0
    ~finish:got_all_letters
    ~f:(fun b c -> if got_all_letters b
                   then Stop true
                   else Continue (add_alpha b c))
