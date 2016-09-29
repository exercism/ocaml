open OUnit2

module type EXPECTED = sig
  type t
  val empty : t
  val equal : t -> t -> bool
  val is_empty : t -> bool
  val is_member : t -> int -> bool
  val is_subset : t -> t -> bool
  val is_disjoint: t -> t -> bool
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
  | (h1::t1), (h2::t2) -> h1 = h2 && int_list_eq t1 t2
  | [], [] -> true
  | _, _ -> false

let int_list_printer l =
  let rec print_els = function
    | (h1::h2::t) -> string_of_int h1 ^ " " ^ print_els (h2::t)
    | (h1::t) -> string_of_int h1 ^ print_els t
    | [] -> "" in
  "[" ^ print_els l ^ "]"

let assert_true exp _text_ctxt = assert_equal exp true
let assert_false exp _text_ctxt = assert_equal exp false
let tests = [
  "sets with no elements are empty">::
    assert_true (CSet.is_empty (CSet.of_list []));
  "sets with elements are not empty">::
    assert_false (CSet.is_empty (CSet.of_list [1]));
  "nothing is contained in the empty set">::
    assert_false (CSet.is_member (CSet.of_list []) 1);
  "when the element is in the set">::
    assert_true (CSet.is_member (CSet.of_list [1;2;3]) 1);
  "when the element is not in the set">::
    assert_false (CSet.is_member (CSet.of_list [1;3;3]) 4);
  "empty set is a subset of an other empty set">::
    assert_true (CSet.is_subset (CSet.of_list []) (CSet.of_list []));
  "empty set is a subset of a non empty set">::
    assert_true (CSet.is_subset (CSet.of_list []) (CSet.of_list [1]));
  "non-empty set is a not subset of an empty set">::
    assert_false (CSet.is_subset (CSet.of_list [1]) (CSet.of_list []));
  "set is a subset of set with exact same elements">::
    assert_true (CSet.is_subset (CSet.of_list [1;2;3]) (CSet.of_list [1;2;3]));
  "set is a subset of larger set with exact same elements">::
    assert_true (CSet.is_subset (CSet.of_list [1;2;3]) (CSet.of_list [4;1;2;3]));
  "set is not a subset of set that does not contain its elements">::
    assert_false (CSet.is_subset (CSet.of_list [1;2;3]) (CSet.of_list [4;1;3]));
  "the empty set is disjoint with itself">::
    assert_true (CSet.is_disjoint (CSet.of_list []) (CSet.of_list []));
  "the empty set is disjoint with non-empty set">::
    assert_true (CSet.is_disjoint (CSet.of_list []) (CSet.of_list [1]));
  "non-empty set is disjoint with empty set">::
    assert_true (CSet.is_disjoint (CSet.of_list [1]) (CSet.of_list []));
  "sets are not disjoint if they share an element">::
    assert_false (CSet.is_disjoint (CSet.of_list [1;2]) (CSet.of_list [2;3]));
  "sets are disjoint if they do not share an element">::
    assert_true (CSet.is_disjoint (CSet.of_list [1;2]) (CSet.of_list [3;4]));
  "empty sets are equal">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.of_list []));
  "empty set is not equal to non-empty set">::
    assert_false (CSet.equal (CSet.of_list []) (CSet.of_list [1;2;3]));
  "non-empty set is not equal to empty set">::
    assert_false (CSet.equal (CSet.of_list [1;2;3]) (CSet.of_list []));
  "sets with the same elements are equal">::
    assert_true (CSet.equal (CSet.of_list [1;2]) (CSet.of_list [2;1]));
  "sets with different elements are not equal">::
    assert_false (CSet.equal (CSet.of_list [1;2;3]) (CSet.of_list [1;2;4]));
  "add to empty set">::
    assert_true (CSet.equal (CSet.of_list [3]) (CSet.add (CSet.of_list []) 3));
  "add to non-empty set">::
    assert_true (CSet.equal (CSet.of_list [1;2;3;4]) (CSet.add (CSet.of_list [1;2;4]) 3));
  "adding existing element does not change set">::
    assert_true (CSet.equal (CSet.of_list [1;2;3]) (CSet.add (CSet.of_list [1;2;3]) 3));
  "intersection of two empty sets is empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.intersect (CSet.of_list []) (CSet.of_list [])));
  "intersection of empty set with non-empty set is an empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.intersect (CSet.of_list []) (CSet.of_list [3;2;5])));
  "intersection of non-empty set with empty set is an empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.intersect (CSet.of_list [1;2;3;4]) (CSet.of_list [])));
  "intersection of sets with no shared elements is empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.intersect (CSet.of_list [1;2;3]) (CSet.of_list [4;5;6])));
  "intersection of set with shared elements is set of shared elements">::
    assert_true (CSet.equal (CSet.of_list [2;3]) (CSet.intersect (CSet.of_list [1;2;3;4]) (CSet.of_list [3;2;5])));
  "difference of two empty sets is an empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.difference (CSet.of_list []) (CSet.of_list [])));
  "difference of empty set and non-empty set is empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.difference (CSet.of_list []) (CSet.of_list [3;2;5])));
  "difference of non-empty set and empty set is the non-empty set">::
    assert_true (CSet.equal (CSet.of_list [1;2;3;4]) (CSet.difference (CSet.of_list [1;2;3;4]) (CSet.of_list [])));
  "difference of two non-empty sets is the sets of elements only in the first set">::
    assert_true (CSet.equal (CSet.of_list [1;3]) (CSet.difference (CSet.of_list [3;2;1]) (CSet.of_list [2;4])));
  "union of two empty sets is an empty set">::
    assert_true (CSet.equal (CSet.of_list []) (CSet.union (CSet.of_list []) (CSet.of_list [])));
  "union of empty set and non-empty set is non-empty set">::
    assert_true (CSet.equal (CSet.of_list [2]) (CSet.union (CSet.of_list []) (CSet.of_list [2])));
  "union of non-empty set and empty set is the non-empty set">::
    assert_true (CSet.equal (CSet.of_list [1;3]) (CSet.union (CSet.of_list [1;3]) (CSet.of_list [])));
  "union of two non-empty sets contains all unique elements">::
    assert_true (CSet.equal (CSet.of_list [1;2;3]) (CSet.union (CSet.of_list [1;3]) (CSet.of_list [2;3])));
  ]

let () =
  run_test_tt_main ("custom_set tests" >::: tests)
