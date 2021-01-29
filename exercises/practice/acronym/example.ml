open Base

let delimiters = [' '; '-'; '_']
let is_relevant c = Char.is_alpha c || List.exists delimiters ~f:(Char.equal c)

let acronym input =
  input
  |> String.filter ~f:is_relevant
  |> String.split_on_chars ~on:delimiters
  |> List.filter ~f:(fun word -> String.length word > 0)
  |> List.map ~f:(fun word -> String.get word 0 |> Char.uppercase) 
  |> String.of_char_list