type palindrome_products = {
  value : int option;
  factors : (int * int) list;
}

(* Returns the smallest palindrome with factors in the given range, or an appropriate
   error result if the range is ill specified, or there are no palindromes in the range. *)
val smallest : min : int -> max : int -> (palindrome_products, string) result

(* Returns the largest palindrome with factors in the given range, or an appropriate
   error result if the range is ill specified, or there are no palindromes in the range. *)
val largest : min : int -> max : int -> (palindrome_products, string) result

(* These are helper functions for tests. They can be written by hand, or using ppx_deriving
   https://github.com/ocaml-ppx/ppx_deriving/blob/master/README.md.
*)

(* Returns a string representation of a palindrome_products. *)
val show_palindrome_products : palindrome_products -> string

(* Returns true if two palindrome_products are equal. *)
val equal_palindrome_products : palindrome_products -> palindrome_products -> bool
