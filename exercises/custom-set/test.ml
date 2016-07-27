open OUnit2

module type EXPECTED = sig
  type t
  val empty : t
  val equal : t -> t -> bool
  val is_empty : t -> bool
  val is_member : t -> int -> bool
  val to_string : t -> string
  val of_list : int list -> t
  val to_list : t -> int list
  val add : t -> int -> t
  val remove : t -> int -> t
  val difference : t -> t -> t
  val intersect : t -> t -> t
  val union : t -> t -> t
end

module CSet : EXPECTED = Custom_set.Make(struct
  type t = int
  let compare a b = compare (a mod 10) (b mod 10)
  let equal a b = compare a b = 0
  let to_string v = string_of_int v
end)

let rec int_list_eq l1 l2 = match (l1, l2) with
  | (h1::t1), (h2::t2) -> h1 == h2 && int_list_eq t1 t2
  | [], [] -> true
  | _, _ -> false

let int_list_printer l =
  let rec print_els = function
    | (h1::h2::t) -> string_of_int h1 ^ " " ^ print_els (h2::t)
    | (h1::t) -> string_of_int h1 ^ print_els t
    | [] -> "" in
  "[" ^ print_els l ^ "]"

let ae_set exp got _test_ctxt = assert_equal ~cmp:CSet.equal ~printer:CSet.to_string exp got
let ae_list exp got _test_ctxt = assert_equal ~cmp:int_list_eq ~printer:int_list_printer exp got
let ae_repr exp set _test_ctxt = assert_equal ~cmp:(=) ~printer:(fun x -> x) exp (CSet.to_string set)
let assert_true exp _text_ctxt = assert_equal exp true
let assert_false exp _text_ctxt = assert_equal exp false
let assert_not_equal exp got _test_ctxt = assert_equal ~cmp:(fun x y -> (CSet.equal x y) |> not) exp got

let tests = [
  "empty">::
    ae_repr "{}" (CSet.empty);
  "is_empty true on the empty set">::
    assert_true (CSet.is_empty CSet.empty);
  "is_empty false on a non-empty set">::
    assert_false (CSet.is_empty (CSet.of_list [1]));
  "is_empty true on a set created from an empty list">::
    assert_true (CSet.is_empty (CSet.of_list []));
  "empty = empty">::
    ae_set (CSet.empty) (CSet.empty);
  "empty != non-empty">::
    assert_not_equal CSet.empty (CSet.of_list [2]);
  "non-empty != empty">::
    assert_not_equal (CSet.of_list [2]) CSet.empty;
  "equal - different non-empty sets">::
    assert_not_equal (CSet.of_list [2]) (CSet.of_list [3]);
  "equal - equal non-empty sets">::
    ae_set (CSet.of_list [2]) (CSet.of_list [2]);
  "is_member false on the empty set">::
    assert_false (CSet.is_member CSet.empty 3);
  "is_member false if not a member">::
    assert_false (CSet.is_member (CSet.of_list [1;2;5]) 3);
  "is_member true if a member">::
    assert_true (CSet.is_member (CSet.of_list [1;3;5]) 3);
  "of_list - no duplicates">::
    ae_repr "{1 2 3}" (CSet.of_list [2;3;1]);
  "of_list - duplicates">::
    ae_repr "{1 2 3}" (CSet.of_list [2;3;2;1;1]);
  "to_list">::
    ae_list [-2; 1; 3] (CSet.to_list (CSet.of_list [3;1;-2]));
  "add non-duplicate">::
    ae_repr "{1 3 4}" (CSet.add (CSet.of_list [1;4]) 3);
  "add duplicate">::
    ae_repr "{1 3 4}" (CSet.add (CSet.of_list [1;4;3]) 3);
  "add onto empty set">::
    ae_repr "{3}" (CSet.add CSet.empty 3);
  "remove found">::
    ae_repr "{1 4}" (CSet.remove (CSet.of_list [1;3;4]) 3);
  "remove not found">::
    ae_repr "{1 4}" (CSet.remove (CSet.of_list [1;4]) 3);
  "remove from empty set">::
    ae_repr "{}" (CSet.remove CSet.empty 3);
  "custom compare">::
    ae_list [1; 2; 3]
      (List.map (fun x -> x mod 10) (CSet.to_list
        (CSet.remove (CSet.add (CSet.of_list [103; 11; 22; 404]) 53) 14)));
  "difference">::
    ae_repr "{1 3 5}"
      (CSet.difference (CSet.of_list [1; 2; 3; 4; 5]) (CSet.of_list [2; 4]));
  "intersect">::
    ae_repr "{1 3}"
      (CSet.intersect (CSet.of_list [1; 2; 3]) (CSet.of_list [3; 5; 1]));
  "union">::
    ae_repr "{1 2 3 5}"
      (CSet.union (CSet.of_list [1; 2; 3]) (CSet.of_list [3; 5; 1]));
  ]

let () =
  run_test_tt_main ("custom_set tests" >::: tests)
