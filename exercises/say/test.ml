open Core.Std
open OUnit2
open Say

let print_result = function
  | None -> "None"
  | Some(x) -> x
                 
let tests =
  ["cannot say numbers below 0">::(fun _ ->
     assert_bool "-1"
                  (in_english (-1L) |> Option.is_none)
   );
   "cannot say numbers above 1 trillion">::(fun _ ->
     assert_bool "1 trillion"
                 (in_english 1_000_000_000_000L |> Option.is_none)
   );
   "zero">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "zero")
                  (in_english 0L)
   );
   "one">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one")
                  (in_english 1L)
   );
   "two">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "two")
                  (in_english 2L)
   );
   "three">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "three")
                  (in_english 3L)
   );
   "seven">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "seven")
                  (in_english 7L)
   );
   "ten">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "ten")
                  (in_english 10L)
   );
   "eleven">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "eleven")
                  (in_english 11L)
   );
   "twelve">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "twelve")
                  (in_english 12L)
   );
   "thirteen">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "thirteen")
                  (in_english 13L)
   );
   "fourteen">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "fourteen")
                  (in_english 14L)
   );
   "fifteen">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "fifteen")
                  (in_english 15L)
   );
   "sixteen">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "sixteen")
                  (in_english 16L)
   );
   "nineteen">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "nineteen")
                  (in_english 19L)
   );
   "twenty">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "twenty")
                  (in_english 20L)
   );
   "twenty-four">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "twenty-four")
                  (in_english 24L)
   );
   "thirty">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "thirty")
                  (in_english 30L)
   );
   "thirty-five">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "thirty-five")
                  (in_english 35L)
   );
   "forty-eight">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "forty-eight")
                  (in_english 48L)
   );
   "fifty-seven">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "fifty-seven")
                  (in_english 57L)
   );
   "sixty">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "sixty")
                  (in_english 60L)
   );
   "seventy-one">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "seventy-one")
                  (in_english 71L)
   );
   "eighty-three">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "eighty-three")
                  (in_english 83L)
   );
   "ninety-nine">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "ninety-nine")
                  (in_english 99L)
   );
   "one hundred">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one hundred")
                  (in_english 100L)
   );
   "one hundred and five">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one hundred five")
                  (in_english 105L)
   );
   "four hundred eighty-five">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "four hundred eighty-five")
                  (in_english 485L)
   );
   "nine hundred ninety-nine">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "nine hundred ninety-nine")
                  (in_english 999L)
   );
   "one thousand">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one thousand")
                  (in_english 1000L)
   );
   "one thousand and two">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one thousand two")
                  (in_english 1002L)
   );
   "one thousand three hundred twenty-three">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one thousand three hundred twenty-three")
                  (in_english 1323L)
   );
   "eight thousand seven hundred and eleven">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "eight thousand seven hundred eleven")
                  (in_english 8711L)
   );
   "nine hundred fifty-eight thousand one hundred forty-five">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "nine hundred fifty-eight thousand one hundred forty-five")
                  (in_english 958145L)
   );
   "one million">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one million")
                  (in_english 1_000_000L)
   );
   "one billion">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "one billion")
                  (in_english 1_000_000_000L)
   );
   "a big number">::(fun _ ->
     assert_equal ~printer:print_result
                  (Some "nine hundred eighty-seven billion six hundred fifty-four million three hundred twenty-one thousand one hundred twenty-three")
                  (in_english 987_654_321_123L)
   );
   "all numbers from 1 to 10_000 can be spelt">::(fun _ ->
     assert_bool "range test" (Sequence.range 0 10_000
       |> Sequence.map ~f:(fun n -> Int64.of_int n |> in_english)
       |> Sequence.filter ~f:(Option.is_none)
       |> Sequence.is_empty));
  ]

let () =
  run_test_tt_main ("say tests" >::: tests)
