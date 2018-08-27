open Base
open OUnit2
open Say

let ae exp got _ctx = assert_equal ~printer:(Option.value ~default:"None") exp got

let tests = [
   "zero" >:: (
      ae (Some "zero")
         (in_english 0L));
   "one" >:: (
      ae (Some "one")
         (in_english 1L));
   "fourteen" >:: (
      ae (Some "fourteen")
         (in_english 14L));
   "twenty" >:: (
      ae (Some "twenty")
         (in_english 20L));
   "twenty-two" >:: (
      ae (Some "twenty-two")
         (in_english 22L));
   "one hundred" >:: (
      ae (Some "one hundred")
         (in_english 100L));
   "one hundred twenty-three" >:: (
      ae (Some "one hundred twenty-three")
         (in_english 123L));
   "one thousand" >:: (
      ae (Some "one thousand")
         (in_english 1000L));
   "one thousand two hundred thirty-four" >:: (
      ae (Some "one thousand two hundred thirty-four")
         (in_english 1234L));
   "one million" >:: (
      ae (Some "one million")
         (in_english 1000000L));
   "one million two thousand three hundred forty-five" >:: (
      ae (Some "one million two thousand three hundred forty-five")
         (in_english 1002345L));
   "one billion" >:: (
      ae (Some "one billion")
         (in_english 1000000000L));
   "a big number" >:: (
      ae (Some "nine hundred eighty-seven billion six hundred fifty-four million three hundred twenty-one thousand one hundred twenty-three")
         (in_english 987654321123L));
   "numbers below zero are out of range" >:: (
      ae None
         (in_english (-1L)));
   "numbers above 999,999,999,999 are out of range" >:: (
      ae None
         (in_english 1000000000000L));
  "all numbers from 1 to 10_000 can be spelt">::(fun _ ->
      assert_bool "range test" (Sequence.range 0 10_000
                                |> Sequence.map ~f:(fun n -> Int64.of_int n |> in_english)
                                |> Sequence.filter ~f:(Option.is_none)
                                |> Sequence.is_empty));
]

let () =
  run_test_tt_main ("say tests" >::: tests)
