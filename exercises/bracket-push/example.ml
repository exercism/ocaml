open Core

type 'a stack = 'a list

let push (s: 'a stack) (a: 'a): 'a stack = a :: s
let pop (s: 'a stack): ('a * 'a stack) option = match s with
  | [] -> None
  | x :: xs -> Some (x, xs)

(* this receives a character from the input string s.
   if the character is an opening bracket, then push it on to the stack, and
   return the stack (inside an Option)
   if the character is a closing bracket, then pop the top of the stack, and
   check the popped character matches. If it does, then return the new stack,
   otherwise return None (to indicate matching failure). *)
let update (s: (char stack) option) (ch: char): (char stack) option =
  match s with
  | None -> None
  | Some s ->
    let pop_matching m = Option.filter (pop s) ~f:(fun (top, _) -> top = m)
                         |> Option.map ~f:snd in
    match ch with
    | '(' | '{' | '[' -> Some (push s ch)
    | ')' -> pop_matching '('
    | '}' -> pop_matching '{'
    | ']' -> pop_matching '['
    | _ -> Some s

(* The fold loops over the characters of s, repeatedly calling update on a stack
   and each character of s.
   If update ever encounters a non-matching bracket, it returns None, and the
   fold will as well.
   Otherwise, the fold will return a stack after going through all of the string.
   If the stack is non-empty, then some non-matching brackets must remain, so the string
   is not balanced.
   If the stack is empty, everything matches, and the string balances.
*)
let are_balanced s =
  List.fold_left (String.to_list s) ~init:(Some []) ~f:update
  |> Option.exists ~f:(List.is_empty)
