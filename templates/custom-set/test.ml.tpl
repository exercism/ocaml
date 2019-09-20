(* {{name}} - {{version}} *)
open OUnit2

module type EXPECTED = sig
  type t
  val of_list : int list -> t
  val is_empty : t -> bool
  val is_member : t -> int -> bool
  val is_subset : t -> t -> bool
  val is_disjoint: t -> t -> bool
  val equal : t -> t -> bool
  val add : t -> int -> t
  val intersect : t -> t -> t
  val difference : t -> t -> t
  val union : t -> t -> t
end

module CSet : EXPECTED = Custom_set.Make(struct
    type t = int
    let compare a b = compare (a mod 10) (b mod 10)
  end)

let ae exp got _test_ctxt = assert_equal exp got
let aec exp got _test_ctxt = assert_equal true (CSet.equal (CSet.of_list exp) got)

let tests = [
  {{#cases}}
    (* {{description}} *)
    {{#cases}}
      "{{description}}" >::
      {{assertion}} {{#input}}{{expected}} ({{module_name}}.{{property}} {{{params}}}{{/input}});
    {{/cases}}
  {{/cases}}
]

let () =
  run_test_tt_main ("custom_set tests" >::: tests)
