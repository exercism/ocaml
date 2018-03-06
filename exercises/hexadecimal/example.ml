open Base

let digit_to_int c =
  match c with
  | '0'..'9'  -> Some (Char.to_int(c) - 48)
  | 'a'..'f'  -> Some (Char.to_int(c) - 97 + 10)
  | 'A'..'F'  -> Some (Char.to_int(c) - 97 + 10)
  | _ -> None

let to_int hex_str =
  let rec go acc = function
    | []    -> acc
    | c::cs -> match digit_to_int c with
                    | Some n -> go (acc * 16 + n) cs
                    | None -> 0 in
  go 0 (String.to_list hex_str)
