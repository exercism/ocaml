open Core.Std

module type ELEMENT = sig
    type t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val to_string : t -> string
end

module Make(El: ELEMENT) = struct
    (* Not terribly efficient, but good enough for this example.
     *
     * The list is kept sorted at all times. *)
    type t = El.t list
    
    type el = El.t
    
    let is_empty = List.is_empty

    let rec is_member l n = List.find l ~f:(El.equal n) |> Option.is_some

    let equal a b = List.equal a b ~equal:El.equal
    
    let to_string l = 
        let rec print_els = function
            | (h1::h2::t) -> El.to_string h1 ^ " " ^ print_els (h2::t)
            | (h1::t) -> El.to_string h1 ^ print_els t
            | [] -> "" in
        "{" ^ print_els l ^ "}"

    let empty = []
    
    let of_list l = List.dedup ~compare:El.compare l |> List.sort ~cmp:El.compare
    
    let to_list l = l 

    let add l x =
        let rec go acc = function
            | h :: t ->
                let r = El.compare x h in
                if r = 0 then l (* element already in the set *)
                else if r < 0 then List.rev_append acc (x :: h :: t)
                else go (h::acc) t
            | [] -> List.rev (x::acc)
        in go [] l

    let remove l x =
        let rec go acc = function
            | h :: t ->
                let r = El.compare x h in
                if r = 0 then List.rev_append acc t
                else if r < 0 then l
                else go (h::acc) t
            | [] -> l 
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
                if r == 0 then go (if f `Both then h1::acc else acc) (t1, t2)
                else if r < 0 then go (if f `OnlyA then h1::acc else acc) (t1, h2::t2)
                else go (if f `OnlyB then h2::acc else acc) (h1::t1, t2)
        in go [] (l1, l2)

    let difference = diff_filter (function `OnlyA -> true | _ -> false)
    let intersect = diff_filter (function `Both -> true | _ -> false)
    let union = diff_filter (fun _ -> true)
end

