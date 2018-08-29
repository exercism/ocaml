open Base
open OUnit2
open Space_age

let ae ~delta:delta exp got _ctxt =
  let msg = Printf.sprintf "Expected %f got %f, difference is greater than %f"
                    exp got delta in
  assert_bool msg (cmp_float ~epsilon:delta exp got)

let tests = [
   "age on Earth" >::
      ae ~delta:0.005 31.69 (age_on Earth 1000000000);
   "age on Mercury" >::
      ae ~delta:0.005 280.88 (age_on Mercury 2134835688);
   "age on Venus" >::
      ae ~delta:0.005 9.78 (age_on Venus 189839836);
   "age on Mars" >::
      ae ~delta:0.005 39.25 (age_on Mars 2329871239);
   "age on Jupiter" >::
      ae ~delta:0.005 2.41 (age_on Jupiter 901876382);
   "age on Saturn" >::
      ae ~delta:0.005 3.23 (age_on Saturn 3000000000);
   "age on Uranus" >::
      ae ~delta:0.005 1.21 (age_on Uranus 3210123456);
   "age on Neptune" >::
      ae ~delta:0.005 1.58 (age_on Neptune 8210123456);
]

let () =
  run_test_tt_main ("space-age tests" >::: tests)
