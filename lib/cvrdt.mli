open Base
(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

module type GCOUNTER = sig
  type t

  val zero : t

  val incr : string -> t -> t

  val value : t -> int64

  val merge : t -> t -> t

  val to_string : t -> string

  val pp : Caml.Format.formatter -> t -> unit [@@ocaml.toplevel_printer]
end

module type PNCOUNTER = sig
  type t

  val zero : t

  val incr : string -> t -> t

  val decr : string -> t -> t

  val value : t -> int64

  val merge : t -> t -> t
end

module type LWWREG = sig
  type 'a t

  val zero : 'a t

  val value : 'a t -> 'a option

  val set : 'a -> float -> 'a t -> 'a t

  val merge : 'a t -> 'a t -> 'a t
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

module GCounter : GCOUNTER

module PNCounter : PNCOUNTER

module LWWReg : LWWREG

module GSet (El : Comparator.S) : GSET with type elt = El.t
