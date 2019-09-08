(* say - 1.2.0 *)
open Base
open OUnit2
open Say

let printer = function
  | Error m -> m |> Printf.sprintf "Error \"%s\""
  | Ok v -> v |> Printf.sprintf "Ok %s"

let ae exp got _ctx = assert_equal ~printer exp got

let tests = [
  "zero" >::
  ae (Ok "zero") (in_english 0L);
  "one" >::
  ae (Ok "one") (in_english 1L);
  "fourteen" >::
  ae (Ok "fourteen") (in_english 14L);
  "twenty" >::
  ae (Ok "twenty") (in_english 20L);
  "twenty-two" >::
  ae (Ok "twenty-two") (in_english 22L);
  "one hundred" >::
  ae (Ok "one hundred") (in_english 100L);
  "one hundred twenty-three" >::
  ae (Ok "one hundred twenty-three") (in_english 123L);
  "one thousand" >::
  ae (Ok "one thousand") (in_english 1000L);
  "one thousand two hundred thirty-four" >::
  ae (Ok "one thousand two hundred thirty-four") (in_english 1234L);
  "one million" >::
  ae (Ok "one million") (in_english 1000000L);
  "one million two thousand three hundred forty-five" >::
  ae (Ok "one million two thousand three hundred forty-five") (in_english 1002345L);
  "one billion" >::
  ae (Ok "one billion") (in_english 1000000000L);
  "a big number" >::
  ae (Ok "nine hundred eighty-seven billion six hundred fifty-four million three hundred twenty-one thousand one hundred twenty-three") (in_english 987654321123L);
  "numbers below zero are out of range" >::
  ae (Error "input out of range") (in_english (-1L));
  "numbers above 999,999,999,999 are out of range" >::
  ae (Error "input out of range") (in_english 1000000000000L);
  "all numbers from 1 to 10_000 can be spelt">::(fun _ ->
      assert_bool "range test" (Sequence.range 0 10_000
                                |> Sequence.map ~f:(fun n -> Int64.of_int n |> in_english)
                                |> Sequence.filter ~f:Result.is_error
                                |> Sequence.is_empty));
]

let () =
  run_test_tt_main ("say tests" >::: tests)
