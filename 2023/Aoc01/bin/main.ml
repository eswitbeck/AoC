let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let list = read_lines filename

let explode_string s = List.init (String.length s) (String.get s) |> List.map Char.escaped

let process_string s =
  let open Re.Pcre in
  explode_string s
    |> List.filter (pmatch ~rex:(regexp "\\d"))
    |> List.fold_left ( ^ ) ""
    |> (fun s -> Char.escaped (String.get s 0) ^ Char.escaped (String.get s (String.length s - 1)))
    |> int_of_string

(*
let () = 
  List.iter
    (fun n -> Printf.printf "%d\n" (process_string n))
    list
    *)
  
let solution_1 = list
  |> List.map process_string
  |> List.fold_left ( + ) 0

(* write maps for each, replace, run same thing *)

let num_references = ["one", "1"; "two", "2"; "three", "3"; "four", "4"; "five",
"5"; "six", "6"; "seven", "7"; "eight", "8"; "nine", "9"]

let new_process_string s =
  let open Re.Pcre in
    Printf.printf "%s\n" s;
    List.fold_left 
      (fun acc (f, t) -> substitute ~rex:(regexp f) ~subst:(fun _ -> t) acc)
      s
      num_references
    |> fun l -> Printf.printf "%s\n" l; l
    |> explode_string
    |> List.filter (pmatch ~rex:(regexp "\\d"))
    |> List.fold_left ( ^ ) ""
    |> (fun s -> Char.escaped (String.get s 0) ^ Char.escaped (String.get s (String.length s - 1)))
    |> fun l -> Printf.printf "%s\n" l; l
    |> int_of_string
    |> fun l -> Printf.printf "%d\n" l; l


let solution_2 = list
  |> List.map new_process_string
  |> List.fold_left ( + ) 0

let () = 
  Printf.printf "%d\n" solution_1
let () = 
  Printf.printf "%d\n" solution_2
