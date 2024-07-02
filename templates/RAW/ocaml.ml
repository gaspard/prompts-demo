(* [prompt] *)
(* ==== SOLUTION ==== *)
(* [solution] *)

(* ==== TEST ==== *)
let metadata = [
  ("author", "your-initials");
  ("dataset", "test");
]

let validate candidate =
  let assert_equal a b = assert(a = b) in
  let assert_throws fn b = try let _ = fn () in 
      raise (Invalid_argument "DID NOT THROW") 
    with | Invalid_argument err -> assert (err = b)
  in
  (* examples *)
  assert_equal (candidate 1) 1;

  (* cases *)
  assert_equal (candidate 1) 1;
  assert_throws (fun () -> candidate 0) "";
;;


let () = validate function_name;;

(* ==== DEFINITION ==== *)
(* [definition] *)