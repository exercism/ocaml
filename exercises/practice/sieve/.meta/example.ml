module IntSet = Set.Make (Int)

let rec mark (start : int) (step : int) (stop : int) (composites : IntSet.t) =
  match (start, step, stop, composites) with
  | start, _step, stop, composites when start > stop -> composites
  | start, step, stop, composites when IntSet.mem start composites ->
      mark (start + step) step stop composites
  | start, step, stop, composites ->
      mark (start + step) step stop (IntSet.add start composites)

let rec sift (start : int) (stop : int) (acc : int list) (composites : IntSet.t)
    =
  match (start, stop, acc, composites) with
  | start, stop, acc, _composites when start > stop -> acc
  | start, stop, acc, composites when IntSet.mem start composites ->
      sift (start + 1) stop acc composites
  | start, stop, acc, composites ->
      sift (start + 1) stop (start :: acc)
        (mark (start * 2) start stop composites)

let primes (limit : int) =
  match limit with
  | limit when limit < 2 -> []
  | limit -> sift 2 limit [] IntSet.empty
