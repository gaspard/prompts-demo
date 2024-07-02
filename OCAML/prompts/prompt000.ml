(* Dummy prompt for CI testing. *)
let dummy (a:int) : int = 
  (* ==== SOLUTION ==== *)
  if a = 0 then raise (Invalid_argument "Should not be 0."); a

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
  assert_equal (candidate 2) 2;

  (* cases *)
  assert_equal (candidate 1) 2;
  assert_throws (fun () -> candidate 0) "Should not be 0.";
;;


let () = validate dummy;;

(* ==== DEFINITION ==== *)
(* Some prompt information would come here. *)