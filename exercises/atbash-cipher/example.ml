open Base

let substitute = function
  | 'a' .. 'z' as c ->
    let offset = (Char.to_int c) - (Char.to_int 'a') in
    let code = (Char.to_int 'z') - offset in
    Char.of_int_exn code
  | other -> other

let is_encodable = function
  | 'a' .. 'z' | '0' .. '9' -> true
  | _ -> false

let explode s =
  let rec expl i l =
    if i < 0 then
      l
    else
      expl (i - 1) (s.[i] :: l)
  in
  expl ((String.length s) - 1) []

let implode l =
  let character_at i = List.nth_exn l i in
  String.init (List.length l) ~f:character_at

let rec group n l =
  if (List.length l) <= n then
    [l]
  else
    (List.take l n) :: (group n (List.drop l n))

let encode ?block_size:(block_size = 5) text =
  let lowercase_text = String.lowercase text in
  let characters = explode lowercase_text in
  let filtered_characters = List.filter ~f:is_encodable characters in
  let groups = group block_size filtered_characters in
  let preprocessed_texts = List.map ~f:implode groups in
  let texts = List.map ~f:(String.map ~f:substitute) preprocessed_texts in
  String.concat ~sep:" " texts

let decode text =
  let lowercase_text = String.lowercase text in
  let characters = explode lowercase_text in
  let filtered_characters = List.filter ~f:is_encodable characters in
  let preprocessed_text = implode filtered_characters in
  String.map ~f:substitute preprocessed_text
