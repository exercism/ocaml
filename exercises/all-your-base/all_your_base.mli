open Core.Std

type base = int

val convert_bases : from: base -> digits: int list -> target: base -> (int list) option
