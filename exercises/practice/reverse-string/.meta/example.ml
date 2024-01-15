let reverse_string str =
  let len = String.length str in
  String.init len (fun i -> str.[len - 1 - i])