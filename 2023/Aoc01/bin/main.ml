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
    |> (fun s -> Char.escaped (String.get s 0) ^ Char.escaped @@ String.get s @@ String.length s - 1)
    |> int_of_string

let solution_1 = list
  |> List.map process_string
  |> List.fold_left ( + ) 0

(* a horrible hack *)
let num_references = ["one", "o1e"; "two", "t2o"; "three", "t3e"; "four", "f4r"; "five",
"f5e"; "six", "s6x"; "seven", "s7n"; "eight", "e8t"; "nine", "n9e"]

let new_process_string s =
  let open Re.Pcre in
    List.fold_left 
      (fun acc (f, t) -> substitute ~rex:(regexp f) ~subst:(fun _ -> t) acc)
      s
      num_references
    |> explode_string
    |> List.filter (pmatch ~rex:(regexp "\\d"))
    |> List.fold_left ( ^ ) ""
    |> (fun s -> Char.escaped (String.get s 0) ^ Char.escaped @@ String.get s @@ String.length s - 1)
    |> int_of_string


let solution_2 = list
  |> List.map new_process_string
  |> List.fold_left ( + ) 0

let () = 
  Printf.printf "Solution 1: %d\n" solution_1
let () = 
  Printf.printf "Solution 2: %d\n" solution_2
