let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let groups =
  let open Re.Pcre in
  let contents = String.trim (read_file filename) in
  split ~rex:(regexp "\n\n") contents
  |> List.map (split ~rex:(regexp "\n"))

let concatted_groups = groups
  |> List.map (List.fold_left ( ^ ) "")

type seen_letters = { mutable list : string; }

let count_unique_answers c_group =
  let seen = { list = "" } in
  String.iter (fun c -> 
    if (String.contains seen.list c)
    then seen.list <- seen.list
    else seen.list <- seen.list ^ (Char.escaped c)) c_group;
  String.length seen.list

let () =
  concatted_groups
  |> List.map count_unique_answers
  |> List.fold_left ( + ) 0
  |> Printf.printf "Total answers part 1: %d.\n"

module String_set = Set.Make(String)

let explode_string s = List.init (String.length s) (String.get s) |> List.map Char.escaped

let set_of_answers answers_string = 
  let rec helper set string_array =
    match string_array with
    | [] -> set
    | hd::tl -> let updated_set = String_set.add hd set in
                helper updated_set tl in 
  let answers_array = explode_string answers_string in
  helper String_set.empty answers_array

let count_every_answers group = 
  List.map set_of_answers group
  |> fun sets -> List.fold_left String_set.inter (List.hd sets) sets
  |> String_set.elements
  |> List.length

let () = 
  groups 
  |> List.map count_every_answers
  |> List.fold_left ( + ) 0
  |> Printf.printf "Total answers part 2: %d.\n"
