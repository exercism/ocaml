open Core.Std
open OUnit2
open Say

(* A wrapper around the assert_equal function from oUnit to reduce the test
   boilerplate. *)
let say_test exp n =
  exp>::(fun _ctx ->
    assert_equal ~printer:(Option.value ~default:"None")
      (Some exp) (in_english n))

let tests = [
  "cannot say numbers below 0">::(fun _ ->
    assert_bool "-1" (in_english (-1L) |> Option.is_none));
  "cannot say numbers above 1 trillion">::(fun _ ->
    assert_bool "1 trillion"
      (in_english 1_000_000_000_000L |> Option.is_none));
  say_test "zero" 0L;
  say_test "one" 1L;
  say_test "two" 2L;
  say_test "three" 3L;
  say_test "seven" 7L;
  say_test "ten" 10L;
  say_test "eleven" 11L;
  say_test "twelve" 12L;
  say_test "thirteen" 13L;
  say_test "fourteen" 14L;
  say_test "fifteen" 15L;
  say_test "sixteen" 16L;
  say_test "seventeen" 17L;
  say_test "eighteen" 18L;
  say_test "nineteen" 19L;
  say_test "twenty" 20L;
  say_test "twenty-four" 24L;
  say_test "thirty" 30L;
  say_test "thirty-five" 35L;
  say_test "forty-eight" 48L;
  say_test "fifty-seven" 57L;
  say_test "sixty" 60L;
  say_test "seventy-one" 71L;
  say_test "eighty-three" 83L;
  say_test "ninety-nine" 99L;
  say_test "one hundred" 100L;
  say_test "one hundred five" 105L;
  say_test "four hundred eighty-five" 485L;
  say_test "nine hundred ninety-nine" 999L;
  say_test "one thousand" 1000L;
  say_test "one thousand two" 1002L;
  say_test "one thousand three hundred twenty-three" 1323L;
  say_test "eight thousand seven hundred eleven" 8711L;
  say_test "nine hundred fifty-eight thousand one hundred forty-five" 958145L;
  say_test "one million" 1_000_000L;
  say_test "one billion" 1_000_000_000L;
  say_test ("nine hundred eighty-seven billion six hundred fifty-four " ^
      "million three hundred twenty-one thousand one hundred " ^
      "twenty-three") 987_654_321_123L;
  "all numbers from 1 to 10_000 can be spelt">::(fun _ ->
    assert_bool "range test" (Sequence.range 0 10_000
      |> Sequence.map ~f:(fun n -> Int64.of_int n |> in_english)
      |> Sequence.filter ~f:(Option.is_none)
      |> Sequence.is_empty));
  ]

let () =
  run_test_tt_main ("say tests" >::: tests)
