open Base
open OUnit2
open Space_age

let ae ~delta:delta exp got _ctxt =
  let msg = Printf.sprintf "Expected %f got %f, difference is greater than %f"
                    exp got delta in
  assert_bool msg (cmp_float ~epsilon:delta exp got)

let tests = [
   "age on Earth" >::
      ae ~delta:0.05 31.69 (age_on Earth 1000000000);
   "age on Mercury" >::
      ae ~delta:0.05 280.88 (age_on Mercury 2134835688);
   "age on Venus" >::
      ae ~delta:0.05 9.78 (age_on Venus 189839836);
   "age on Mars" >::
      ae ~delta:0.05 35.88 (age_on Mars 2129871239);
   "age on Jupiter" >::
      ae ~delta:0.05 2.41 (age_on Jupiter 901876382);
   "age on Saturn" >::
      ae ~delta:0.05 2.15 (age_on Saturn 2000000000);
   "age on Uranus" >::
      ae ~delta:0.05 0.46 (age_on Uranus 1210123456);
   "age on Neptune" >::
      ae ~delta:0.05 0.35 (age_on Neptune 1821023456);
]

let () =
  run_test_tt_main ("space-age tests" >::: tests)