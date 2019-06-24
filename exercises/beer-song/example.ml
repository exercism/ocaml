open Base

let bottles = function
    | 0 -> "no more bottles"
    | 1 -> "1 bottle"
    | n -> Int.to_string n ^ " bottles"

let line1 n =
    let b = bottles n in
    Printf.sprintf "%s of beer on the wall, %s of beer.\n" b b

let line2 n =
    Printf.sprintf "Take %s down and pass it around, %s of beer on the wall."
            (if n > 0 then "one" else "it") (bottles n)

let verse = function
    | 0 -> String.capitalize (line1 0) ^
           "Go to the store and buy some more, 99 bottles of beer on the wall."
    | n -> line1 n ^ line2 (n-1)

let recite start bottles =
    List.range ~stride:(-1) ~stop:`exclusive start (start - bottles)
    |> List.map ~f:verse
    |> String.concat ~sep:"\n\n"
