module type ELEMENT = sig
    type t
    val compare : t -> t -> int
end

module Make(El: ELEMENT) = struct
    type t = El.t list
    type el = El.t

    let el_equal _ _ = 
      failwith "'el_equal' is missing"

    let is_empty _ =
      failwith "'is_empty' is missing" 

    let is_member _ _ = 
      failwith "'is_member' is missing" 

    let is_subset _ _ =
      failwith "'is_subset' is missing" 

    let is_disjoint _ _ = 
      failwith "'is_disjoint' is missing" 

    let equal _ _ =
      failwith "'equal' is missing" 

    let of_list _ =
      failwith "'of_list' is missing" 

    let add _ _ =
      failwith "'add' is missing" 

    type status = [
        | `OnlyA
        | `OnlyB
        | `Both
    ]

    let diff_filter _ _ _ =
      failwith "'diff_filter' is missing" 

    let difference _ _ = 
      failwith "'difference' is missing" 

    let intersect _ _ = 
      failwith "'intersect' is missing" 

    let union _ _ = 
      failwith "'union' is missing" 
end
