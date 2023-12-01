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
