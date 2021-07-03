(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

open Base
open Cvrdt
module C = GCounter

module To_test = struct
  let gcounter_zero () =
    let c = C.zero in
    Int64.(C.value c = 0L)

  let gcounter_incr () =
    let c = C.zero |> C.incr "a" |> C.incr "a" |> C.incr "b" in
    Int64.(C.value c = 3L)

  let gcounter_merge () =
    let c1 = C.zero |> C.incr "a" |> C.incr "a" |> C.incr "b" in
    let c2 = C.zero |> C.incr "b" |> C.incr "b" in
    let c3 = C.merge c1 c2 in
    Int64.(C.value c3 = 4L)
end

let gcounter_zero () =
  Alcotest.(check bool) "zero" true (To_test.gcounter_zero ())

let gcounter_incr () =
  Alcotest.(check bool) "incr" true (To_test.gcounter_incr ())

let gcounter_merge () =
  Alcotest.(check bool) "merge" true (To_test.gcounter_merge ())

let tests =
  [
    ("zero", `Quick, gcounter_zero);
    ("incr", `Quick, gcounter_incr);
    ("merge", `Quick, gcounter_merge);
  ]
