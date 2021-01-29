open Base

(* Spells out a number from 0 to 999,999,999,999 in English.
   If the input is outside that range, then an Error is returned.
   E.g in_english 100L = Some "one hundred"
       in_english (-1)L = Error ""
 *)
val in_english : int64 -> (string, string) Result.t