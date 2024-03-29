open OUnit2
open Palindrome_products

module For_tests = struct
  type palindrome_products = Palindrome_products.palindrome_products = {
    value : int option;
    factors : (int * int) list;
  } [@@deriving eq, show]
end

open For_tests

let show_result printer = function
  | Error e -> "Error " ^ e
  | Ok a -> "Ok " ^ printer a

let eq_results eq x y = match (x, y) with
  | (Error e1, Error e2) -> String.equal e1 e2
  | (Ok x, Ok y) -> eq x y
  | _ -> false

let ae exp got _test_ctxt =
  assert_equal ~printer:(show_result show_palindrome_products) ~cmp:(eq_results equal_palindrome_products) exp got

let tests = [
  "find the smallest palindrome from single digit factors" >::
  ae (Ok {value=(Some 1); factors=[(1,1)]})
    (smallest ~min:1 ~max:9);
  "find the largest palindrome from single digit factors" >::
  ae (Ok {value=(Some 9); factors=[(1,9); (3,3)]})
    (largest ~min:1 ~max:9);
  "find the smallest palindrome from double digit factors" >::
  ae (Ok {value=(Some 121); factors=[(11,11)]})
    (smallest ~min:10 ~max:99);
  "find the largest palindrome from double digit factors" >::
  ae (Ok {value=(Some 9009); factors=[(91,99)]})
    (largest ~min:10 ~max:99);
  "find the smallest palindrome from triple digit factors" >::
  ae (Ok {value=(Some 10201); factors=[(101,101)]})
    (smallest ~min:100 ~max:999);
  "find the largest palindrome from triple digit factors" >::
  ae (Ok {value=(Some 906609); factors=[(913,993)]})
    (largest ~min:100 ~max:999);
  "find the smallest palindrome from four digit factors" >::
  ae (Ok {value=(Some 1002001); factors=[(1001,1001)]})
    (smallest ~min:1000 ~max:9999);
  "find the largest palindrome from four digit factors" >::
  ae (Ok {value=(Some 99000099); factors=[(9901,9999)]})
    (largest ~min:1000 ~max:9999);
  "empty result for smallest if no palindrome in the range" >::
  ae (Ok {value=None; factors=[]})
    (smallest ~min:1002 ~max:1003);
  "empty result for largest if no palindrome in the range" >::
  ae (Ok {value=None; factors=[]})
    (largest ~min:15 ~max:15);
  "error result for smallest if min is more than max" >::
  ae (Error "min must be <= max")
    (smallest ~min:10000 ~max:1);
  "error result for largest if min is more than max" >::
  ae (Error "min must be <= max")
    (largest ~min:2 ~max:1);
  "smallest product does not use the smallest factor" >::
  ae (Ok {value=(Some 10988901); factors=[(3297,3333)]})
    (smallest ~min:3215 ~max:4000);
]

let () =
  ignore @@ run_test_tt_main ("palindrome product tests" >::: tests)
