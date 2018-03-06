
open OUnit2
open Grade_school

let assert_lists_equal exp got _ctx =
  let printer = String.concat ";" in
  assert_equal exp got ~printer

let tests = [
  "an empty school has no children in grade 1" >::
    assert_lists_equal [] (grade 1 empty_school);
  "an empty school has Emma in grade 1 after she's been added to grade 1" >::(
    let s = add "Emma" 1 empty_school in
    assert_lists_equal ["Emma"] (grade 1 s)
  );
  "an empty school does not have Emma in grade 1 after she's been added to grade 2" >::(
    let s = add "Emma" 2 empty_school in
    assert_lists_equal [] (grade 1 s)
  );
  "an empty school has Emma, Timmy, Bob and Becky in grade 1 after they've been added to grade 1" >::(
    let s = empty_school |> add "Emma" 1 |> add "Timmy" 1 |> add "Bob" 1 |> add "Becky" 1 in
    assert_lists_equal ["Becky"; "Bob"; "Emma"; "Timmy"] (grade 1 s |> List.sort compare)
  );
  "a sorted school has Emma, Timmy, Bob and Becky in grade 1 in sorted order" >::(
    let s = empty_school |> add "Emma" 1 |> add "Timmy" 1 |> add "Bob" 1 |> add "Becky" 1 |> sorted in
    assert_lists_equal ["Becky"; "Bob"; "Emma"; "Timmy"] (grade 1 s)
  );
]

let () =
  run_test_tt_main ("grade-school tests" >::: tests)
