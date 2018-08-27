open Base
open OUnit2
open Prime_factors

(* Assert Equals *)
let ae exp got _test_ctxt =
  let printer xs = List.map xs ~f:Int64.to_string |> String.concat ~sep:";" in
  assert_equal exp got ~printer

let to_int64s = List.map ~f:Int64.of_int

(* 64 bits integers are needed for the last number.
 *
 * If you happen to use a 64 bits machine normal ints would do as well, but this
 * works for everybody.
 *)
let tests = [
   "no factors" >::
      ae (to_int64s []) (factors_of 1L);
   "prime number" >::
      ae (to_int64s [2]) (factors_of 2L);
   "square of a prime" >::
      ae (to_int64s [3; 3]) (factors_of 9L);
   "cube of a prime" >::
      ae (to_int64s [2; 2; 2]) (factors_of 8L);
   "product of primes and non-primes" >::
      ae (to_int64s [2; 2; 3]) (factors_of 12L);
   "product of primes" >::
      ae (to_int64s [5; 17; 23; 461]) (factors_of 901255L);
   "factors include a large prime" >::
      ae (to_int64s [11; 9539; 894119]) (factors_of 93819012551L);
]

let () =
  run_test_tt_main ("prime-factors tests" >::: tests)
