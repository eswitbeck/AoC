let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let list = read_lines filename

let adapt line =
  let split_line line = 
    match Str.split (Str.regexp ": ") line with
    | counts::string::[] -> (counts, string)
    | _ -> (" ", " ") in
  let split_counts (counts, b) =
    match Str.split (Str.regexp " ") counts with
    | range::letter::[] -> (range, String.get letter 0, b)
    | _ -> (" ", ' ', b) in
  let split_range (range, b, c) = 
    match Str.split (Str.regexp "-") range with
    | low::high::[] -> (int_of_string low, int_of_string high, b, c)
    | _ -> (-1, -1, b, c) in
  split_range (split_counts (split_line line))


let input = List.map adapt list

let is_valid_list (low, high, letter, string) =
  let c =
    String.fold_left (fun c ch -> if ch = letter then c + 1 else c) 0 string in
  c >= low && c <= high

let bool_list = List.map is_valid_list input

let solution_1 =
  let fold_add_if_true count bool =
    if bool then count + 1 else count in
  List.fold_left fold_add_if_true 0 bool_list

let is_valid_list_2 (first, second, letter, string) =
  (String.get string (first - 1) = letter &&
  String.get string (second - 1) <> letter) ||
  (String.get string (second - 1) = letter &&
  String.get string (first - 1) <> letter)

let bool_list_2 = List.map is_valid_list_2 input

let solution_2 =
  let fold_add_if_true count bool =
    if bool then count + 1 else count in
  List.fold_left fold_add_if_true 0 bool_list_2 

let () = 
  Printf.printf "%d\n" solution_1

let () = 
  Printf.printf "%d\n" solution_2
