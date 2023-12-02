let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let list = read_lines filename

let parse_line l = 
  let open Re.Pcre in 
  let set = extract ~rex:(regexp "Game (\\d+): (.*)") l in
  let split_body = split ~rex:(regexp "; ") set.(2) in
  let extract_game_data game = 
    let results = extract ~rex:(regexp "(\\d+) (blue|red|green)") game in
    (int_of_string results.(1), results.(2)) in
  (int_of_string set.(1), List.map (split ~rex:(regexp ", ")) split_body |> List.map (List.map extract_game_data))
  (*
    int * (int * string) list list
  *)

let is_valid_game (_ , body) = (* game of rounds of pulls *)
  let is_valid_pull (count, color) =
    match color with
    | "blue" -> count <= 14
    | "green" -> count <= 13
    | "red" -> count <= 12
    | _ -> raise Not_found in
  let is_valid_round = 
    List.fold_left (fun acc pull -> acc && is_valid_pull pull) true in
  List.map is_valid_round body
  |> List.fold_left ( && ) true

let () = list
  |> List.map parse_line
  |> List.filter is_valid_game
  |> List.map (fun (number, _) -> number)
  |> List.fold_left ( + ) 0
  (*
  |> List.fold_left
      (fun acc (game_number, body) -> 
        Printf.printf "%d: \n" game_number;
        List.iter (List.iter (fun (n, g_t) -> Printf.printf "%s %d\n" g_t n)) body;
        acc) 
      0
  *)
  |> (Printf.printf "Solution 1: %d\n")
      
