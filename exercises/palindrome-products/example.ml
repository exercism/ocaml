open Core

type palindrome_products = {
  value : int;
  factors : (int * int) list;
} [@@deriving show, eq]

let invalid_input_error min max =
  Error (sprintf "invalid input: min is %d and max is %d" min max)

let is_palindrome n =
  let n = Int.to_string n in String.rev n = n

let to_palindrome_products (xs : (int * (int * int)) list): palindrome_products =
  let value = fst (List.hd_exn xs) in
  let factors = List.map ~f:snd xs in
  {value; factors}

let seq stride = Sequence.range ~start:`inclusive ~stop:`inclusive ~stride

let smallest ~min ~max =
  if min > max
  then invalid_input_error min max
  else 
    let open Sequence.Monad_infix in
    let seq = seq 1 in
    let products = 
      seq min max >>= fun x -> 
      seq x max >>= fun y -> 
      Sequence.singleton (x * y, (x, y)) 
      |> Sequence.filter ~f:(fun (n, _) -> is_palindrome n) in
    products
      |> Sequence.to_list
      |> List.sort ~cmp:(fun (x,_) (y,_) -> Int.compare x y)
      |> List.group ~break:(fun (x, _) (y, _) -> x <> y)
      |> List.hd
      |> Option.map ~f:to_palindrome_products
      |> Result.of_option ~error:(sprintf "no palindrome with factors in the range %d to %d" min max)

let largest ~min ~max = 
  if min > max
  then invalid_input_error min max
  else 
    let open Sequence.Monad_infix in
    let seq = seq (-1) in
    let products = 
      seq max min >>= fun x -> 
      seq x min >>= fun y -> 
      Sequence.singleton (x * y, (y, x)) 
      |> Sequence.filter ~f:(fun (n, _) -> is_palindrome n) in
    products
      |> Sequence.to_list
      |> List.sort ~cmp:(fun (x,_) (y,_) -> Int.compare y x)
      |> List.group ~break:(fun (x, _) (y, _) -> x <> y)
      |> List.hd
      |> Option.map ~f:to_palindrome_products
      |> Result.of_option ~error:(sprintf "no palindrome with factors in the range %d to %d" min max)

  