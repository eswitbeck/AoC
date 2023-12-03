let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents
  |> Array.of_list
  |> Array.map (fun l -> Array.init (String.length l) (String.get l))

let matrix = read_lines filename

let touches_symbol i j arr =
  let directions = [-1; 0; 1] in
  let directional_vectors = 
    List.map (fun d1 -> List.map (fun d2 -> (d1, d2)) directions) directions
      |> List.flatten in
   directional_vectors
    |> List.map (fun (x1, y1) -> 
      let x2 = j + x1 in
      let y2 = i + y1 in
      (y2 >= 0 && y2 < Array.length arr) &&
      (x2 >= 0 && x2 < Array.length arr.(0)) &&
      Re.Pcre.pmatch ~rex:(Re.Pcre.regexp "[^\\d\\.]") (Char.escaped arr.(y2).(x2)))
     |> List.exists (fun a -> a)

let is_digit arr i j = Re.Pcre.pmatch ~rex:(Re.Pcre.regexp "\\d") (Char.escaped arr.(i).(j))

let convert_line_to_numbers full_arr i line =
  let rec helper numbers_list number_buffer touched j =
    let flush_buffer () = if String.length number_buffer <> 0 && touched
      then Some (int_of_string number_buffer)
      else None in
    if j = Array.length line then 
      match flush_buffer () with
        | Some n -> n::numbers_list
        | None -> numbers_list
    else if is_digit full_arr i j && touches_symbol i j full_arr then 
      helper numbers_list (number_buffer ^ (Char.escaped line.(j))) true (j + 1)
    else if is_digit full_arr i j  then (* digit but not touching; continue *)
      helper numbers_list (number_buffer ^ (Char.escaped line.(j))) touched (j + 1)
    else (* terminating case *)
      match flush_buffer () with
        | Some n -> helper (n::numbers_list) "" false (j + 1) 
        | None -> helper numbers_list "" false (j + 1) in
  helper [] "" false 0

let () = 
  matrix
    |> (fun a -> Array.mapi (convert_line_to_numbers a) a)
    |> Array.to_list
    |> List.flatten
    |> List.fold_left ( + ) 0
    |> Printf.printf "%d\n"


(* two pass solution for part 2:
  pre-process into strings, where every digit is replaced by the whole number
    ie [
        1, 2, 3, ., .
        *, ., ., . 1
       ] becomes
       [
        123, 123, 123, ., .
        *,     .,   ., ., 1
       ]
  then do a seek for symbols, retrieving numbers

  get preprocessed version
  get list = map aross outer array with
    map across inner array
      if symbol, check all coords
        if 2 matches, add to list
        else continue
  |> flatten
  |> reduce
  *)
