type t

type progress =
    | Win
    | Lose
    | Busy of int

let create _ =
    failwith "'create' is missing"

let feed _ _ =
    failwith "'feed' is missing"

let masked_word _ =
    failwith "'masked_word' is missing"

let progress _ =
    failwith "'progress' is missing"
