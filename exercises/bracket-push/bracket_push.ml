open Core.Std

module type MonadSig = sig
  type 'a t
  val (>>=): 'a t -> ('a -> 'b t) -> 'b t
  val return : 'a -> 'a t
end

module MonadOps (M : MonadSig) = struct
  open M
  let foldM (xs: 'a list) (z: 'b) ~f =
    List.fold xs ~init:(return z) ~f:(fun b a -> (b >>= (fun b -> f b a)))
end

module OptionMonadOps = MonadOps(Option)

type 'a stack = 'a list

let push (s: 'a stack) (a: 'a): 'a stack = a :: s
let pop (s: 'a stack): ('a * 'a stack) option = match s with
  | [] -> None
  | x :: xs -> Some (x, xs)

let update (s: char stack) (ch: char): (char stack) option =
  let pop_matching m = Option.filter (pop s) ~f:(fun (top, _) -> top = m) |> Option.map ~f:snd in
  match ch with
  | '(' | '{' | '[' -> Some (push s ch)
  | ')' -> pop_matching '('
  | '}' -> pop_matching '{'
  | ']' -> pop_matching '['
  | _ -> Some s

let are_balanced s =
  OptionMonadOps.foldM (String.to_list s) ([]) ~f:update |> Option.exists ~f:(List.is_empty)
