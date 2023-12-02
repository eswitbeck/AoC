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
  |> Printf.printf "Solution 1: %d\n"
      
let max_across_pulls (blue, green, red) (count, color) =
  match color with
  | "blue" -> if count > blue then (count, green, red) else (blue, green, red)
  | "green" -> if count > green then (blue, count, red) else (blue, green, red)
  | "red" -> if count > red then (blue, green, count) else (blue, green, red)
  | _ -> raise Not_found

(* (int * string) list -> (int * int * int) *)
let get_round_count = List.fold_left max_across_pulls (0, 0, 0)

let max_across_rounds (b1, g1, r1) (b2, g2, r2) =
  let b = if b2 > b1 then b2 else b1 in
  let g = if g2 > g1 then g2 else g1 in
  let r = if r2 > r1 then r2 else r1 in
  (b, g, r)

let get_counts (_, body) =
  List.map get_round_count body
  |> List.fold_left max_across_rounds (0, 0, 0)

let () = list
  |> List.map parse_line
  |> List.map get_counts
  |> List.map (fun (b, g, r) -> b * g * r)
  |> List.fold_left ( + ) 0
  |> Printf.printf "Solution 2: %d\n"
