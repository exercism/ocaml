open OUnit2
open Atbash_cipher

let ae exp got _test_ctxt = assert_equal ~printer:(fun x -> x) exp got

{{#cases}}
  let {{{description}}}_tests = [
    {{#cases}}
      "{{description}}" >::
        ae {{#input}}{{expected}} ({{property}} {{phrase}}){{/input}};
    {{/cases}}
  ]


{{/cases}}

let different_block_size_test = [
  "encode mindblowingly with a different block size" >::
    ae "n r m w y o l d r m t o b" (encode ~block_size:1 "mindblowingly");
]

let () =
  run_test_tt_main (
    "atbash-cipher tests" >:::
      List.concat [{{#cases}}{{description}}_tests; {{/cases}}different_block_size_test]
  )
