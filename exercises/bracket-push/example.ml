open Base
open Base.Continue_or_stop

(* Fold over the characters of s. When an open bracket is met, push this onto a
   stack. When a close bracket is met, and the most recent open bracket matches
   it, pop this from the stack. When a close bracket is met that doesn't match
   an open bracket (empty stack, or mismatching top-element of stack), stop. *)
let are_balanced =
  String.fold_until ~init:[] ~finish:List.is_empty
    ~f:(fun stack c -> match stack, c with
      | _, '[' | _, '{' | _, '(' -> Continue (c::stack)
      | '['::bs, ']' -> Continue bs
      | '{'::bs, '}' -> Continue bs
      | '('::bs, ')' -> Continue bs
      | _, ']' | _, '}' | _, ')' -> Stop false
      | _ -> Continue stack)
