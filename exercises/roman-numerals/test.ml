(* roman-numerals - 1.2.0 *)
open OUnit2
open Roman_numerals

let ae expected actual _ctx = assert_equal ~printer:(fun x -> x) expected actual

let tests = [
  "1 is a single I" >::
  ae "I" (to_roman 1);
  "2 is two I's" >::
  ae "II" (to_roman 2);
  "3 is three I's" >::
  ae "III" (to_roman 3);
  "4, being 5 - 1, is IV" >::
  ae "IV" (to_roman 4);
  "5 is a single V" >::
  ae "V" (to_roman 5);
  "6, being 5 + 1, is VI" >::
  ae "VI" (to_roman 6);
  "9, being 10 - 1, is IX" >::
  ae "IX" (to_roman 9);
  "20 is two X's" >::
  ae "XXVII" (to_roman 27);
  "48 is not 50 - 2 but rather 40 + 8" >::
  ae "XLVIII" (to_roman 48);
  "49 is not 40 + 5 + 4 but rather 50 - 10 + 10 - 1" >::
  ae "XLIX" (to_roman 49);
  "50 is a single L" >::
  ae "LIX" (to_roman 59);
  "90, being 100 - 10, is XC" >::
  ae "XCIII" (to_roman 93);
  "100 is a single C" >::
  ae "CXLI" (to_roman 141);
  "60, being 50 + 10, is LX" >::
  ae "CLXIII" (to_roman 163);
  "400, being 500 - 100, is CD" >::
  ae "CDII" (to_roman 402);
  "500 is a single D" >::
  ae "DLXXV" (to_roman 575);
  "900, being 1000 - 100, is CM" >::
  ae "CMXI" (to_roman 911);
  "1000 is a single M" >::
  ae "MXXIV" (to_roman 1024);
  "3000 is three M's" >::
  ae "MMM" (to_roman 3000);
]

let () =
  run_test_tt_main ("roman-numerals test" >::: tests)
