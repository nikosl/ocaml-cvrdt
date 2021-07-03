(**
 * Copyright (c) 2021 Nikos Leivadaris
 * 
 * This software is released under the MIT License.
 * https://opensource.org/licenses/MIT
 *)

let () =
  Alcotest.run "CvRDT"
    [
      ("GCounter", Test_gcounter.tests);
      ("PNCounter", Test_pncounter.tests);
      ("GSET", Test_gset.tests);
      ("LWWReg", Test_lwwreg.tests);
    ]
