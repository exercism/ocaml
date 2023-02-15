module type ELEMENT = sig
  type t
  val compare : t -> t -> int
end

module Make :
  functor (El : ELEMENT) ->
    sig
      type t
      type el = El.t
      val el_equal : el -> el -> bool
      val is_empty : t -> bool
      val is_member : t -> el -> bool
      val is_subset : t -> t -> bool
      val is_disjoint : t -> t -> bool
      val equal : t -> t -> bool
      val of_list : El.t list -> t
      val add : t -> el -> t
      type status = [ `Both | `OnlyA | `OnlyB ]
      val diff_filter :
        (status -> bool) -> t -> t -> t
      val difference : t -> t -> t
      val intersect : t -> t -> t
      val union : t -> t -> t
    end
