open Core.Std

type 'a stack = 'a list

let push (s: 'a stack) (a: 'a): 'a stack = a :: s
let pop (s: 'a stack): ('a * 'a stack) option = match s with
  | [] -> None
  | x :: xs -> Some (x, xs)

let foldThroughOptionMonad (xs: 'a list) (z: 'b) ~(f:'b -> 'a -> 'b option): 'b option =
  List.fold xs ~init:(Some z) ~f:(fun b a -> match b with
      | None -> None
      | Some b -> f b a
    )

let update (s: char stack) (ch: char): (char stack) option =
  let pop_matching m = Option.filter (pop s) ~f:(fun (top, _) -> top = m) |> Option.map ~f:snd in
  match ch with
  | '(' | '{' | '[' -> Some (push s ch)
  | ')' -> pop_matching '('
  | '}' -> pop_matching '{'
  | ']' -> pop_matching '['
  | _ -> Some s

let are_balanced s =
  foldThroughOptionMonad (String.to_list s) ([]) ~f:update |> Option.exists ~f:(List.is_empty)
