(lang dune 3.11)
(context (default
 (name ox)
 (profile release)
 (env (_
   (flags (:standard -warn-error -A -w -67-69-55-215 -alert=-unsafe_multidomain))
   (ocamlopt_flags (:standard -zero-alloc-check none -O3))))))
