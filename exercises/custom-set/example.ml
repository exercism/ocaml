module type ELEMENT = sig
    type t
    val compare : t -> t -> int
    val equal : t -> t -> bool
end

module Make(El: ELEMENT) = struct
    (* Not terribly efficient, but good enough for this example.
     *
     * The list is kept sorted at all times. *)
    type t = El.t list

    type el = El.t

    let is_empty = function
      | [] -> true
      | _ -> false

    let is_member l n = List.filter (El.equal n) l |> is_empty |> not

    let rec is_subset x y = match (x, y) with
      | ([], []) -> true
      | ([], _)  -> true
      | (_, [])  -> false
      | ((x::xs), y) -> (is_member y x) && (is_subset xs y)

    let rec is_disjoint x y = match (x, y) with
      | ([], []) -> true
      | ([], _)  -> true
      | (_, [])  -> true
      | ((x::xs), y) -> (not (is_member y x)) && (is_disjoint xs y)

    let rec equal x y = match (x, y) with
      | ([], []) -> true
      | ([], _) -> false
      | (_, []) -> false
      | ((x::xs), (y::ys)) -> El.equal x y && equal xs ys

    let of_list = List.sort_uniq El.compare

    let add l x =
        let rec go acc = function
            | h :: t ->
                let r = El.compare x h in
                if r = 0 then l (* element already in the set *)
                else if r < 0 then List.rev_append acc (x :: h :: t)
                else go (h::acc) t
            | [] -> List.rev (x::acc)
        in go [] l

    type status = [
        | `OnlyA
        | `OnlyB
        | `Both
    ]

    let diff_filter (f : status -> bool) l1 l2 =
        let rec go acc = function
            | [], [] -> List.rev acc
            | (h1::t1), [] -> go (if f `OnlyA then h1::acc else acc) (t1, [])
            | [], (h2::t2) -> go (if f `OnlyB then h2::acc else acc) ([], t2)
            | (h1::t1), (h2::t2) ->
                let r = El.compare h1 h2 in
                if r = 0 then go (if f `Both then h1::acc else acc) (t1, t2)
                else if r < 0 then go (if f `OnlyA then h1::acc else acc) (t1, h2::t2)
                else go (if f `OnlyB then h2::acc else acc) (h1::t1, t2)
        in go [] (l1, l2)

    let difference = diff_filter (function `OnlyA -> true | _ -> false)
    let intersect = diff_filter (function `Both -> true | _ -> false)
    let union = diff_filter (fun _ -> true)
end
