open Core

let is_empty = String.for_all ~f:Char.is_whitespace

let is_shouting s =
  String.exists ~f:Char.is_alpha s &&
  String.for_all ~f:(fun c -> not (Char.is_alpha c) || Char.is_uppercase c) s

let is_question s = s.[String.length s - 1] = '?'

let response_for s = 
  let s = String.strip s in 
  match s with
  | s when is_empty s    -> "Fine. Be that way!"
  | s when is_shouting s -> if is_question s then "Calm down, I know what I'm doing!" else "Whoa, chill out!"
  | s when is_question s -> "Sure."
  | _                    -> "Whatever."
