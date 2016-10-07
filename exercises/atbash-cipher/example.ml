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

let rec take n l =
  match (n, l) with
  | (0, _) -> []
  | (_, []) -> []
  | (_, x::xs) -> x::(take (n-1) xs)

let rec drop n l =
  match (n, l) with
  | (0, _) -> l
  | (_, []) -> []
  | (_, _::xs) -> drop (n-1) xs

let rec group n l =
  if (List.length l) < n then
    [l]
  else
    (take n l) :: (group n (drop n l))

let encode ?block_size:(block_size = 5) word =
  let lowercase_word = String.lowercase word in
  let characters = explode lowercase_word in
  let filtered_characters = List.filter is_encodable characters in
  let groups = group block_size filtered_characters in
  let preprocessed_words = List.map implode groups in
  let words = List.map (fun (word) -> (String.map substitute word)) preprocessed_words in
  String.concat " " words

let decode word =
  let lowercase_word = String.lowercase word in
  let characters = explode lowercase_word in
  let filtered_characters = List.filter is_encodable characters in
  let preprocessed_word = implode filtered_characters in
  String.map substitute preprocessed_word
