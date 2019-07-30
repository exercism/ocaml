open Base

module Int_map = Map.M(Int)
type school = string list Int_map.t

let empty_school = Map.empty (module Int)

let add _ _ _ = 
    failwith "'add' is missing"

let grade _ _ =
    failwith "'grade' is missing"

let sorted _ = 
    failwith "'sorted' is missing"