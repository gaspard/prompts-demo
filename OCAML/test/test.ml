
let () =
  let src_dir = "OCAML/prompts" in
  Sys.readdir src_dir
  |> Array.to_list
  |> List.filter (fun file -> Filename.check_suffix file ".ml")
  |> List.iter (fun file ->
      let full_path = Filename.concat src_dir file in
      if Sys.command ("ocaml " ^ full_path) <> 0 then 
        failwith "OCaml test fail"
    )
