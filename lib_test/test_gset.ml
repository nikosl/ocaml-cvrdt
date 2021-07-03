(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

open Base
open Cvrdt
module M = GSet

module To_test = struct
  let gset_empty () =
    let module S = M (String) in
    let s = S.empty in
    S.is_empty s

  let gset_add () =
    let module S = M (String) in
    let s = S.empty |> S.add "a" in
    S.lookup "a" s

  let gset_lookup () =
    let module S = M (String) in
    let s = S.empty |> S.add "a" in
    S.lookup "a" s && not (S.lookup "b" s)

  let gset_merge () =
    let module S = M (String) in
    let s1 = S.empty |> S.add "a" in
    let s2 = S.empty |> S.add "b" in
    let s3 = S.merge s1 s2 in
    S.lookup "a" s3 && S.lookup "b" s3
end

let gset_empty () = Alcotest.(check bool) "empty" true (To_test.gset_empty ())

let gset_add () = Alcotest.(check bool) "add" true (To_test.gset_add ())

let gset_lookup () =
  Alcotest.(check bool) "lookup" true (To_test.gset_lookup ())

let gset_merge () = Alcotest.(check bool) "merge" true (To_test.gset_merge ())

let tests =
  [
    ("empty", `Quick, gset_empty);
    ("add", `Quick, gset_add);
    ("lookup", `Quick, gset_lookup);
    ("merge", `Quick, gset_merge);
  ]
