open OUnit2

module type EXPECTED = sig
  type t
  val of_list : int list -> t
  val is_empty : t -> bool
  val is_member : t -> int -> bool
  val is_subset : t -> t -> bool
  val is_disjoint: t -> t -> bool
  val equal : t -> t -> bool
  val add : t -> int -> t
  val intersect : t -> t -> t
  val difference : t -> t -> t
  val union : t -> t -> t
end

module CSet : EXPECTED = Custom_set.Make(struct
    type t = int
    let compare a b = compare (a mod 10) (b mod 10)
  end)

let ae exp got _test_ctxt = assert_equal exp got
let aec exp got _test_ctxt = assert_equal true (CSet.equal (CSet.of_list exp) got)

let tests = [
  (* Returns true if the set contains no elements *)
  "sets with no elements are empty" >::
  ae true (CSet.is_empty (CSet.of_list []));
  "sets with elements are not empty" >::
  ae false (CSet.is_empty (CSet.of_list [1]));
  (* Sets can report if they contain an element *)
  "nothing is contained in an empty set" >::
  ae false (CSet.is_member (CSet.of_list []) 1);
  "when the element is in the set" >::
  ae true (CSet.is_member (CSet.of_list [1; 2; 3]) 1);
  "when the element is not in the set" >::
  ae false (CSet.is_member (CSet.of_list [1; 2; 3]) 4);
  (* A set is a subset if all of its elements are contained in the other set *)
  "empty set is a subset of another empty set" >::
  ae true (CSet.is_subset (CSet.of_list []) (CSet.of_list []));
  "empty set is a subset of non-empty set" >::
  ae true (CSet.is_subset (CSet.of_list []) (CSet.of_list [1]));
  "non-empty set is not a subset of empty set" >::
  ae false (CSet.is_subset (CSet.of_list [1]) (CSet.of_list []));
  "set is a subset of set with exact same elements" >::
  ae true (CSet.is_subset (CSet.of_list [1; 2; 3]) (CSet.of_list [1; 2; 3]));
  "set is a subset of larger set with same elements" >::
  ae true (CSet.is_subset (CSet.of_list [1; 2; 3]) (CSet.of_list [4; 1; 2; 3]));
  "set is not a subset of set that does not contain its elements" >::
  ae false (CSet.is_subset (CSet.of_list [1; 2; 3]) (CSet.of_list [4; 1; 3]));
  (* Sets are disjoint if they share no elements *)
  "the empty set is disjoint with itself" >::
  ae true (CSet.is_disjoint (CSet.of_list []) (CSet.of_list []));
  "empty set is disjoint with non-empty set" >::
  ae true (CSet.is_disjoint (CSet.of_list []) (CSet.of_list [1]));
  "non-empty set is disjoint with empty set" >::
  ae true (CSet.is_disjoint (CSet.of_list [1]) (CSet.of_list []));
  "sets are not disjoint if they share an element" >::
  ae false (CSet.is_disjoint (CSet.of_list [1; 2]) (CSet.of_list [2; 3]));
  "sets are disjoint if they share no elements" >::
  ae true (CSet.is_disjoint (CSet.of_list [1; 2]) (CSet.of_list [3; 4]));
  (* Sets with the same elements are equal *)
  "empty sets are equal" >::
  ae true (CSet.equal (CSet.of_list []) (CSet.of_list []));
  "empty set is not equal to non-empty set" >::
  ae false (CSet.equal (CSet.of_list []) (CSet.of_list [1; 2; 3]));
  "non-empty set is not equal to empty set" >::
  ae false (CSet.equal (CSet.of_list [1; 2; 3]) (CSet.of_list []));
  "sets with the same elements are equal" >::
  ae true (CSet.equal (CSet.of_list [1; 2]) (CSet.of_list [2; 1]));
  "sets with different elements are not equal" >::
  ae false (CSet.equal (CSet.of_list [1; 2; 3]) (CSet.of_list [1; 2; 4]));
  "set is not equal to larger set with same elements" >::
  ae false (CSet.equal (CSet.of_list [1; 2; 3]) (CSet.of_list [1; 2; 3; 4]));
  (* Unique elements can be added to a set *)
  "add to empty set" >::
  aec [3] (CSet.add (CSet.of_list []) 3);
  "add to non-empty set" >::
  aec [1; 2; 3; 4] (CSet.add (CSet.of_list [1; 2; 4]) 3);
  "adding an existing element does not change the set" >::
  aec [1; 2; 3] (CSet.add (CSet.of_list [1; 2; 3]) 3);
  (* Intersection returns a set of all shared elements *)
  "intersection of two empty sets is an empty set" >::
  aec [] (CSet.intersect (CSet.of_list []) (CSet.of_list []));
  "intersection of an empty set and non-empty set is an empty set" >::
  aec [] (CSet.intersect (CSet.of_list []) (CSet.of_list [3; 2; 5]));
  "intersection of a non-empty set and an empty set is an empty set" >::
  aec [] (CSet.intersect (CSet.of_list [1; 2; 3; 4]) (CSet.of_list []));
  "intersection of two sets with no shared elements is an empty set" >::
  aec [] (CSet.intersect (CSet.of_list [1; 2; 3]) (CSet.of_list [4; 5; 6]));
  "intersection of two sets with shared elements is a set of the shared elements" >::
  aec [2; 3] (CSet.intersect (CSet.of_list [1; 2; 3; 4]) (CSet.of_list [3; 2; 5]));
  (* Difference (or Complement) of a set is a set of all elements that are only in the first set *)
  "difference of two empty sets is an empty set" >::
  aec [] (CSet.difference (CSet.of_list []) (CSet.of_list []));
  "difference of empty set and non-empty set is an empty set" >::
  aec [] (CSet.difference (CSet.of_list []) (CSet.of_list [3; 2; 5]));
  "difference of a non-empty set and an empty set is the non-empty set" >::
  aec [1; 2; 3; 4] (CSet.difference (CSet.of_list [1; 2; 3; 4]) (CSet.of_list []));
  "difference of two non-empty sets is a set of elements that are only in the first set" >::
  aec [1; 3] (CSet.difference (CSet.of_list [3; 2; 1]) (CSet.of_list [2; 4]));
  (* Union returns a set of all elements in either set *)
  "union of empty sets is an empty set" >::
  aec [] (CSet.union (CSet.of_list []) (CSet.of_list []));
  "union of an empty set and non-empty set is the non-empty set" >::
  aec [2] (CSet.union (CSet.of_list []) (CSet.of_list [2]));
  "union of a non-empty set and empty set is the non-empty set" >::
  aec [1; 3] (CSet.union (CSet.of_list [1; 3]) (CSet.of_list []));
  "union of non-empty sets contains all unique elements" >::
  aec [3; 2; 1] (CSet.union (CSet.of_list [1; 3]) (CSet.of_list [2; 3]));
]

let () =
  run_test_tt_main ("custom_set tests" >::: tests)
