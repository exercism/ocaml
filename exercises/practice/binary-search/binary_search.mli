open Base

(* Finds an int in an array of ints via binary search *)
val find : int array -> int -> (int, string) Result.t