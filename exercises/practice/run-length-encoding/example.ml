open Base

let (>|>) f g x = g (f x)

let repeat n ch = 
  Array.init n ~f:(fun _ -> ch) 
  |> Array.to_list
  |> String.of_char_list

let collapse = function
| [] -> failwith "empty string not expected here"
| [x] -> Char.to_string x
| (x::_) as g -> Printf.sprintf "%d%c" (List.length g) x

let to_int = String.of_char_list >|> Int.of_string

let decode_to_tuple (s: 'a list): ((int * 'a) * 'a list) = 
  match List.split_while ~f:Char.is_digit s with
  | ([], (x::xs)) -> ((1, x), xs)
  | (ds, (x::xs)) -> let count = to_int ds in ((count, x), xs)
  | _ -> failwith "case not expected"

let encode =
  String.to_list
  >|> List.group ~break:(Char.(<>))
  >|> List.map ~f:collapse
  >|> String.concat ~sep:""

let decode = 
  let rec go acc input =
    if List.is_empty input then acc
    else let (t, rest) = decode_to_tuple input in go (t :: acc) rest in
  String.to_list
  >|> go []
  >|> List.rev
  >|> List.map ~f:(fun (cnt, c) -> repeat cnt c)
  >|> String.concat ~sep:""