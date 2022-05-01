(* Based off the Haskell solution by Tarmean at http://exercism.org/submissions/6dc2eef7e7eb469d8657111fc4389fc0 *)

open Base

type dominoe = int * int

(* Functions from Haskell that I can't find in Core! *)

let zip_with (xs: 'a list) (ys: 'b list) ~(f: 'a -> 'b -> 'c) = 
  let rec go xs ys acc = match (xs,ys) with
  | (x::xs,y::ys) -> go xs ys @@ (f x y)::acc
  | _ -> acc
  in
  List.rev @@ go xs ys []

let tails (xs: 'a list): ('a list) list =
  let rec go acc = function
  | [] -> [] :: acc
  | (_::xs) as l -> go (l :: acc) xs
  in
  List.rev @@ go [] xs

let inits (xs: 'a list): ('a list) list =
  List.rev xs |> tails |> List.map ~f:List.rev |> List.rev

let listToOption = function
| [] -> None
| (x :: _) -> Some x

(* The implementation *)

let left (ds: dominoe list): int = ds |> List.hd_exn |> fst
let right (ds: dominoe list): int = ds |> List.last_exn |> snd
let choose_from (ls: 'a list): ('a * 'a list) list =
  List.zip_exn ls @@ zip_with ~f:List.append (inits ls) (List.tl_exn (tails ls))

let rec attach_to path ((a, b), rest) =
  let lp = left path in
  if b = lp then go rest ((a,b)::path)
  else if a = lp then go rest ((b,a)::path)
  else []
and go stones path = match stones with
| [] -> if left path = right path then [path] else []
| _ -> let open List.Monad_infix in choose_from stones >>= attach_to path

let chain_non_empty (first: dominoe) (rest: dominoe list): (dominoe list) option = 
  listToOption @@ go rest [first]

let chain = function
| [] -> Some []
| first::rest -> chain_non_empty first rest