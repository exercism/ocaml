let letter_scores = function
    | 'A' | 'E' | 'I' | 'O' | 'U' | 'L' | 'N' | 'R' | 'S' | 'T' -> 1
    | 'D' | 'G' -> 2
    | 'B' | 'C' | 'M' | 'P' -> 3
    | 'F' | 'H' | 'V' | 'W' | 'Y' -> 4
    | 'K' -> 5
    | 'J' | 'X' -> 8
    | 'Q' | 'Z' -> 10
    | _ -> 0


let score s =
  let chars = s |> String.to_seq |> List.of_seq |> List.map (fun c -> Char.uppercase_ascii c) in
  let rec aux charlist acc =
    match charlist with
    | [] -> acc
    | head :: tail -> aux tail (acc + (letter_scores head))
  in
  aux chars 0