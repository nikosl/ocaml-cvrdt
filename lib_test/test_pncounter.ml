(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

open Base
open Cvrdt
module C = PNCounter

module To_test = struct
  let pncounter_zero () =
    let c = C.zero in
    Int64.(C.value c = 0L)

  let pncounter_incr () =
    let c = C.zero |> C.incr "a" |> C.incr "a" |> C.incr "b" in
    Int64.(C.value c = 3L)

  let pncounter_decr () =
    let c = C.zero |> C.incr "a" |> C.incr "a" |> C.incr "b" |> C.decr "a" in
    Int64.(C.value c = 2L)

  let pncounter_merge () =
    let c1 = C.zero |> C.incr "a" |> C.incr "a" |> C.incr "b" in
    let c2 = C.zero |> C.incr "b" |> C.incr "b" in
    let c3 = C.merge c1 c2 in
    Int64.(C.value c3 = 4L)
end

let pncounter_zero () =
  Alcotest.(check bool) "zero" true (To_test.pncounter_zero ())

let pncounter_incr () =
  Alcotest.(check bool) "incr" true (To_test.pncounter_incr ())

let pncounter_decr () =
  Alcotest.(check bool) "incr" true (To_test.pncounter_decr ())

let pncounter_merge () =
  Alcotest.(check bool) "merge" true (To_test.pncounter_merge ())

let tests =
  [
    ("zero", `Quick, pncounter_zero);
    ("incr", `Quick, pncounter_incr);
    ("decr", `Quick, pncounter_decr);
    ("merge", `Quick, pncounter_merge);
  ]
