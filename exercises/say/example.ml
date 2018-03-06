open Base

let rec in_english_impl = let open Int64 in function
  | 0L -> "zero"
  | 1L -> "one"
  | 2L -> "two"
  | 3L -> "three"
  | 4L -> "four"
  | 5L -> "five"
  | 6L -> "six"
  | 7L -> "seven"
  | 8L -> "eight"
  | 9L -> "nine"
  | 10L -> "ten"
  | 11L -> "eleven"
  | 12L -> "twelve"
  | 13L -> "thirteen"
  | 14L -> "fourteen"
  | 15L -> "fifteen"
  | 16L -> "sixteen"
  | 17L -> "seventeen"
  | 18L -> "eighteen"
  | 19L -> "nineteen"
  | 20L -> "twenty"
  | 30L -> "thirty"
  | 40L -> "forty"
  | 50L -> "fifty"
  | 60L -> "sixty"
  | 70L -> "seventy"
  | 80L -> "eighty"
  | 90L -> "ninety"
  | n when n <= 99L ->
     in_english_impl (10L * (n / 10L)) ^ "-" ^ in_english_impl (n % 10L)
  | n when n <= 999L ->
     in_english_impl (n / 100L) ^ " hundred" ^
       let rem = n % 100L in
       if rem = 0L then "" else " " ^ in_english_impl rem
  | n when n <= 999_999L ->
     in_english_impl (n / 1_000L) ^ " thousand" ^
       let rem = n % 1_000L in
       if rem = 0L then "" else " " ^ in_english_impl rem
  | n when n <= 999_999_999L ->
     in_english_impl (n / 1_000_000L) ^ " million" ^
       let rem = n % 1_000_000L in
       if rem = 0L then "" else " " ^ in_english_impl rem
  | n ->
     in_english_impl (n / 1_000_000_000L) ^ " billion" ^
       let rem = n % 1_000_000_000L in
       if rem = 0L then "" else " " ^ in_english_impl rem

let in_english n =
  if Int64.(n < 0L || n >= 1_000_000_000_000L) then None else Some (in_english_impl n)
