let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let groups =
  let open Re.Pcre in
  let contents = String.trim (read_file filename) in
  split ~rex:(regexp "\n\n") contents
  |> List.map (split ~rex:(regexp "\n"))

let () =
  groups
    |> List.map (l -> 
      Printf.printf "%s\n" l)

(* reduce each; find max *)

let solution_1 =
  groups
    |> List.map (fun l -> List.map int_of_string l)
    |> List.map (fun l -> List.fold_left ( + ) 0 l)
    |> List.fold_left (fun a b -> if a > b then a else b) 0

let () = 
  Printf.printf "%d\n" solution_1
(*
let () = 
  Printf.printf "%d\n" solution_2
  *)
