open Base
open Base.Continue_or_stop

let is_nucleotide = function
  | 'A' | 'C' | 'G' | 'T' -> true
  | _ -> false

let count_nucleotide s c =
  if not (is_nucleotide c) then Error c else
    String.fold_until s
      ~init:0
      ~finish:Result.return
      ~f:(fun n c' -> if not (is_nucleotide c') then Stop (Error c') else
                        Continue (if Char.equal c c' then n+1 else n))

let count_nucleotides =
  let incr = Map.change ~f:(function
                 | None -> Some 1
                 | Some n -> Some (n + 1))
  in String.fold_until
       ~init:(Map.empty (module Char))
       ~finish:Result.return
       ~f:(fun acgt c -> if is_nucleotide c
                         then Continue (incr acgt c)
                         else Stop (Error c))
