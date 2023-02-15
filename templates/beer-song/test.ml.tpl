open Base
open OUnit2
open Beer_song

let zip s1 s2 =
  let rec go s1 s2 acc = match (s1,s2) with
  | ([], _) -> acc
  | (_, []) -> acc
  | (x::xs, y::ys) -> go xs ys ((x,y)::acc) in List.rev @@ go s1 s2 []

 let find_diffs s1 s2 =
   let s1 = String.to_list s1 in
   let s2 = String.to_list s2 in
   let both = zip s1 s2 in
   List.find_mapi both ~f:(fun i (c1, c2) -> if Char.(c1 = c2) then None else Some (Printf.sprintf "Diff at index %d: %c <> %c" i c1 c2))

 let diff_message s1 s2 = match find_diffs s1 s2 with
 | None -> if String.length s1 = String.length s2 then "" else "Lengths of expected and actual differ but have a common prefix."
 | Some m -> m

 let ae exp got _test_ctxt =
   if String.(exp = got)
    then ()
    else failwith @@ "Expected differs from actual: " ^ (diff_message exp got)

{{#cases}}
let {{{slug}}}_tests = [
  {{#cases}}
    {{#cases}}
      "{{description}}" >::
      ae {{#input}}{{expected}}
      ({{property}} {{startBottles}} {{takeDown}}){{/input}};
    {{/cases}}
  {{/cases}}
]


{{/cases}}

let () =
  run_test_tt_main (
    "beer song tests" >:::
      List.concat [
        {{#cases}}
          {{{slug}}}_tests;
        {{/cases}}
      ]
  )
