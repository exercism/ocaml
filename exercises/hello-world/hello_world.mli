(*
   Return a greeting to an optional subject

   ## Examples

   ### greet None
   "Hello, World!"

   ### greet Some("Alice")
   "Hello, Alice!"
*)
val greet: string option -> string
