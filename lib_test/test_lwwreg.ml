(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

open Base
open Cvrdt
module R = LWWReg

module To_test = struct
  let lwwreg_zero () =
    let c = R.zero in
    Option.is_none (R.value c)

  let lwwreg_set () =
    let c = R.zero |> R.set 10 (Unix.gettimeofday ()) in
    Option.mem (R.value c) 10 ~equal:(fun x y -> x = y)

  let lwwreg_set_newer () =
    let t1 = Unix.gettimeofday () in
    let t2 = t1 +. 1000. in
    let c = R.zero |> R.set 10 t1 in
    let c = c |> R.set 20 t2 in
    Option.mem (R.value c) 20 ~equal:(fun x y -> x = y)

  let lwwreg_set_keep_newer () =
    let t1 = Unix.gettimeofday () in
    let t2 = t1 +. 1000. in
    let c = R.zero |> R.set 10 t2 in
    let c = c |> R.set 20 t1 in
    Option.mem (R.value c) 10 ~equal:(fun x y -> x = y)

  let lwwreg_merge () =
    let t1 = Unix.gettimeofday () in
    let t2 = t1 +. 1000. in
    let c1 = R.zero |> R.set 10 t1 in
    let c2 = R.zero |> R.set 20 t2 in
    let c3 = R.merge c1 c2 in
    Option.mem (R.value c3) 20 ~equal:(fun x y -> x = y)
end

let lwwreg_zero () = Alcotest.(check bool) "zero" true (To_test.lwwreg_zero ())

let lwwreg_set () = Alcotest.(check bool) "set" true (To_test.lwwreg_set ())

let lwwreg_set_newer () =
  Alcotest.(check bool) "set newer" true (To_test.lwwreg_set_newer ())

let lwwreg_set_keep_newer () =
  Alcotest.(check bool) "set keep newer" true (To_test.lwwreg_set_keep_newer ())

let lwwreg_merge () =
  Alcotest.(check bool) "merge" true (To_test.lwwreg_merge ())

let tests =
  [
    ("zero", `Quick, lwwreg_zero);
    ("set", `Quick, lwwreg_set);
    ("set-update", `Quick, lwwreg_set_newer);
    ("set-ignore", `Quick, lwwreg_set_keep_newer);
    ("merge", `Quick, lwwreg_merge);
  ]
