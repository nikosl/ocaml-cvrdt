(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

open Base

module type GCOUNTER = sig
  type t

  val zero : t

  val incr : string -> t -> t

  val value : t -> int64

  val merge : t -> t -> t

  val to_string : t -> string

  val pp : Caml.Format.formatter -> t -> unit
end

module GCounter : GCOUNTER = struct
  type t = (string, int64, String.comparator_witness) Map.t

  let zero : t = Map.empty (module String)

  let incr id (gcounter : t) : t =
    let count : int64 =
      match Map.find gcounter id with None -> 0L | Some x -> x
    in
    gcounter |> Map.set ~key:id ~data:Int64.(count + 1L)

  let value (gcounter : t) =
    gcounter |> Map.fold ~f:(fun ~key:_ ~data:x acc -> Int64.(x + acc)) ~init:0L

  let merge (a : t) (b : t) : t =
    a
    |> Map.fold
         ~f:(fun ~key ~data acc ->
           match Map.find acc key with
           | Some data' -> Map.set ~key ~data:Int64.(max data data') acc
           | None -> Map.set ~key ~data acc)
         ~init:b

  let to_string (gcounter : t) : string =
    let s = "]" in
    let b =
      Map.fold ~init:s
        ~f:(fun ~key ~data acc ->
          "(" ^ key ^ ":" ^ Int64.to_string data ^ ")" ^ acc)
        gcounter
    in
    "[" ^ b ^ " = " ^ Int64.to_string (value gcounter)

  let pp ppf (gcounter : t) : unit =
    Caml.Format.pp_print_string ppf (to_string gcounter)
end

module type PNCOUNTER = sig
  type t

  val zero : t

  val incr : string -> t -> t

  val decr : string -> t -> t

  val value : t -> int64

  val merge : t -> t -> t
end

module PNCounter : PNCOUNTER = struct
  type t = GCounter.t * GCounter.t

  let zero : t = (GCounter.zero, GCounter.zero)

  let incr id (pncounter : t) : t =
    let inc, dec = pncounter in
    (GCounter.incr id inc, dec)

  let decr id (pncounter : t) : t =
    let inc, dec = pncounter in
    (inc, GCounter.incr id dec)

  let value (pncounter : t) =
    let inc, dec = pncounter in
    Int64.(GCounter.value inc - GCounter.value dec)

  let merge (a : t) (b : t) : t =
    let a1, a2 = a in
    let b1, b2 = b in
    (GCounter.merge a1 b1, GCounter.merge a2 b2)
end

module type LWWREG = sig
  type 'a t

  val zero : 'a t

  val value : 'a t -> 'a option

  val set : 'a -> float -> 'a t -> 'a t

  val merge : 'a t -> 'a t -> 'a t
end

module LWWReg : LWWREG = struct
  type 'a t = 'a option * float

  let zero : 'a t = (None, 0.0)

  let value ((v, _at) : 'a t) : 'a option = v

  let set (v : 'a) (at : float) (reg : 'a t) : 'a t =
    let _, at' = reg in
    if Float.(at' <= at) then (Some v, at) else reg

  let merge (a : 'a t) (b : 'a t) : 'a t =
    let _, at = a in
    let _, at' = b in
    if Float.(at' <= at) then a else b
end

module type GSET = sig
  type elt

  type t

  val empty : t

  val is_empty : t -> bool

  val length : t -> int

  val add : elt -> t -> t

  val lookup : elt -> t -> bool

  val merge : t -> t -> t
end

module GSet (El : Comparator.S) : GSET with type elt = El.t = struct
  type elt = El.t

  type t = (elt, El.comparator_witness) Set.t

  let empty : t = Set.empty (module El)

  let is_empty (t : t) : bool = Set.is_empty t

  let length (t : t) : int = Set.length t

  let add (elt : elt) (t : t) : t = Set.add t elt

  let lookup (elt : elt) (t : t) : bool = Set.mem t elt

  let merge (a : t) (b : t) : t = Set.union a b
end
