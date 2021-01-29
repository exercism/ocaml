open Base
open OUnit2

let char_of_variant = function
  | `A -> 'A' | `C -> 'C' | `G -> 'G' | `T -> 'T' | `U -> 'U'
let printer l = List.map ~f:char_of_variant l |> String.of_char_list
let ae exp got _test_ctxt = assert_equal ~printer exp got

let tests =
  ["transcribes empty list">::
   ae [] (Rna_transcription.to_rna []);
   "transcribes cytidine">::
   ae [`G] (Rna_transcription.to_rna [`C]);
   "transcribes guanosine">::
   ae [`C] (Rna_transcription.to_rna [`G]);
   "transcribes adenosie">::
   ae [`U] (Rna_transcription.to_rna [`A]);
   "transcribes thymidine">::
   ae [`A] (Rna_transcription.to_rna [`T]);
   "transcribes multiple">::
   ae [`U; `G; `C; `A; `C; `C; `A; `G; `A; `A; `U; `U]
     (Rna_transcription.to_rna [`A; `C; `G; `T; `G; `G; `T; `C; `T; `T; `A; `A])
  ]

let () =
  run_test_tt_main ("rna-transcription tests" >::: tests)
