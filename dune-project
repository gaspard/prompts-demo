(lang dune 2.9)

(name demo)

(wrapped_executables false)

(generate_opam_files true)

(use_standard_c_and_cxx_flags false)

(package
 (depends
  (ocaml
   (= 4.14.2))
  (ounit2
   (= 2.2.7)))
 (name demo)
 (maintainers "Demo")
 (authors "Demo")
 (synopsis "Demo Code Project"))
