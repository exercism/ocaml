let greet subject =
  match subject with
  | None    -> "Hello, World!"
  | Some(s) -> String.concat "" ["Hello, "; s; "!"]
