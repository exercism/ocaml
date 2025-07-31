let is_valid s =
  let chars = List.init (String.length s) (String.get s) in

  let is_digit c = c >= '0' && c <= '9' in

  let rec aux chars acc count =
    match chars with
    | [] ->
      if count <> 10 then false
      else acc mod 11 = 0
    | c :: rest ->
      if c = '-' || c = ' ' then
        aux rest acc count
      else if count = 9 && c = 'X' then
        aux rest (acc + 10 * (count + 1)) (count + 1)
      else if is_digit c then
        let value = int_of_char c - int_of_char '0' in
        aux rest (acc + value * (count + 1)) (count + 1)
      else
        false
  in

  aux chars 0 0
