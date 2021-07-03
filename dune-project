(lang dune 2.8)

(name cvrdt)
(version 0.0.1)

(generate_opam_files true)

(source
 (github nikosl/ocaml-cvrdt))

(license MIT)

(authors "Nikos Leivadaris")

(maintainers "nikosleiv@gmail.com")

(package
 (name cvrdt)
 (synopsis "A library for CvRDT")
 (description "This library provides CvRDTs")
 (depends
  (ocaml (>= 4.12.0))
  (alcotest :with-test)
  (dune (> 2.0))))
