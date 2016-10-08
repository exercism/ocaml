open Core

let substitute = function
  | 'a' .. 'z' as c ->
    let offset = (Char.code c) - (Char.code 'a') in
    let code = (Char.code 'z') - offset in
    Char.chr code
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
  let character_at i = List.nth l i in
  String.init (List.length l) character_at

let rec group n l =
  if (List.length l) <= n then
    [l]
  else
    (Core_list.take l n) :: (group n (Core_list.drop l n))

let encode ?block_size:(block_size = 5) text =
  let lowercase_text = String.lowercase text in
  let characters = explode lowercase_text in
  let filtered_characters = List.filter is_encodable characters in
  let groups = group block_size filtered_characters in
  let preprocessed_texts = List.map implode groups in
  let texts = List.map (String.map substitute) preprocessed_texts in
  String.concat " " texts

let decode text =
  let lowercase_text = String.lowercase text in
  let characters = explode lowercase_text in
  let filtered_characters = List.filter is_encodable characters in
  let preprocessed_text = implode filtered_characters in
  String.map substitute preprocessed_text
