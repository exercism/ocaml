
let two_fer name =
  match name with
  | Some x -> "One for " ^ x ^ ", one for me."
  | None -> "One for you, one for me."
