open Base
open OUnit2

let ael exp got _test_ctxt =
    let sort = List.sort ~compare:Int.compare in
        assert_equal (sort exp) (sort got) ~printer:(fun xs -> String.concat ~sep:";" (List.map ~f:Int.to_string xs)) 

let tests = [
{{#cases}}
    "{{description}}" >::
        ael {{#input}}{{expected}} (Sieve.primes {{limit}}{{/input}});
{{/cases}}
]

let () =
  run_test_tt_main ("sieve tests" >::: tests)
