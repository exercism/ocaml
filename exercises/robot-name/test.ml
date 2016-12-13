open Core.Std
open OUnit2
open Robot_name

let regex = Re2.Regex.create_exn "[A-Z]{2}\\d{3}$"

let basic_tests = [
  "a robot has a name of 2 letters followed by 3 numbers" >:: (fun _ctxt ->
    let n = name (new_robot ()) in
    assert_bool ("'" ^ n ^ "' does not meet the specification") (Re2.Regex.matches regex n)
    );

  "resetting a robot's name gives it a different name" >:: (fun _ctxt ->
    let r = new_robot () in
    let n1 = name r in
    reset r;
    let n2 = name r in
    assert_bool ("'" ^ n1 ^ "' was repeated") (n1 <> n2)
    );

  "after reset the robot's name still matches the specification" >:: (fun _ctxt ->
    let r = new_robot () in
    reset r;
    let n = name r in
    assert_bool ("'" ^ n ^ "' does not meet the specification") (Re2.Regex.matches regex n)
    );
]

(*
Optionally: make this test pass.

There are 26 * 26 * 10 * 10 * 10 = 676,000 possible Robot names.
This test generates all possible Robot names, and checks that there are
no duplicates.

If you want to do this, uncomment the code in the run_test_tt_main
line at the bottom of this module.
*)
let unique_name_tests = [
  "all possible robot names are distinct" >:: (fun _ctxt ->
    let rs = Array.init (26 * 26 * 1000) ~f:(fun _ -> new_robot ()) in
    let (repeated, _) = Array.fold rs ~init:(String.Set.empty, String.Set.empty) ~f:(fun (repeated, seen) r ->
      let n = name r in
      if Set.mem seen n
      then (Set.add repeated n, seen)
      else (repeated, Set.add seen n)
      ) in
    let first_few_repeats = Array.slice (Set.to_array repeated) 0 (min 20 (Set.length repeated)) in
    let failure_message = "first few repeats: " ^ (String.concat_array first_few_repeats ~sep:",") in
    assert_bool failure_message (Set.is_empty repeated)
    );
]

let () =
  run_test_tt_main ("robot-name tests" >::: List.concat [basic_tests (* ; unique_name_tests *)])
