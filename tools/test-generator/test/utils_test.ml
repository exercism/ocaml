open Core
open OUnit2
open Generator.Utils

let utils_tests = [
  "array findi is None if nothing in array matches predicate" >::(fun ctxt ->
      let found = find_arrayi [|"1";"123";"12345";"12"|] ~f:(fun x -> String.length x = 8) ~start:0 in
      assert_equal None found
    );

  "array findi is None if nothing in array matches predicate after start" >::(fun ctxt ->
      let found = find_arrayi [|"1";"123";"12345";"12"|] ~f:(fun x -> String.length x = 1) ~start:1 in
      assert_equal None found
    );

  "array findi is Some including index and value something matches predicate after start" >::(fun ctxt ->
      let found = find_arrayi [|"1";"123";"12345";"12"|] ~f:(fun x -> String.length x = 5) ~start:1 in
      assert_equal (Some (2, "12345")) found
    );
]
