open Base

let (>|>) f g x = f (g x)

let acronym = 
  let acronymChar = function 
  | "" -> ""
  | s when String.(uppercase s = s) -> Char.to_string s.[0]
  | s -> Char.to_string (Char.uppercase s.[0]) ^ String.filter ~f:Char.is_uppercase (String.drop_prefix s 1) in
  String.concat ~sep:""
  >|> List.map ~f:acronymChar
  >|> String.split_on_chars ~on:[' ';'-']
