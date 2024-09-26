let tail (word: string) = 
  String.sub word 1 ((String.length word) - 1)

let rec is_unique (ch: char) (word: string) : bool =
  match (ch, word) with
  | (_, "") -> true
  | (c, w) when c < 'a' || c > 'z' -> is_unique (String.get w 0) (tail w)
  | (c, w) when (String.contains w c) -> false 
  | (_, w) -> is_unique (String.get w 0) (tail w)

let is_isogram (word: string) : bool =
  let lower_word = String.lowercase_ascii word in
  match lower_word with
  | "" -> true
  | w -> is_unique(String.get w 0) (tail w)
