open Base

let every_second_digit_doubled =
  let double_digit n = let d = n * 2 in if d >= 10 then d - 9 else d in
  List.rev_mapi ~f:(fun i -> if i % 2 = 1 then double_digit else Fn.id)

let valid s =
  let s = String.filter s ~f:(fun ch -> Char.(ch <> ' ')) in
  if String.length s > 1
  then
    if String.exists s ~f:(Fn.non Char.is_digit)
    then false
    else
      let checksum = String.to_list s
      |> List.rev_map ~f:(fun ch -> Char.to_int ch - Char.to_int '0')
      |> every_second_digit_doubled
      |> List.sum (module Int) ~f:Fn.id in
      checksum % 10 = 0
  else false