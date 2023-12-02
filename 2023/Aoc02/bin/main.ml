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
  (int_of_string set.(1), List.map (split ~rex:(regexp ", ")) split_body |> List.map @@ List.map extract_game_data)

let is_valid_game (_ , body) = 
  let is_valid_pull (count, color) =
    match color with
    | "blue" -> count <= 14
    | "green" -> count <= 13
    | "red" -> count <= 12
    | _ -> raise Not_found in
  let is_valid_round = List.for_all is_valid_pull in
  List.map is_valid_round body
  |> List.fold_left ( && ) true

let () = list
  |> List.map parse_line
  |> List.filter is_valid_game
  |> List.map fst
  |> List.fold_left ( + ) 0
  |> Printf.printf "Solution 1: %d\n"
      
let max_across_pulls (blue, green, red) (count, color) =
  match color with
  | "blue" -> (Int.max blue count, green, red)
  | "green" -> (blue, Int.max green count, red)
  | "red" -> (blue, green, Int.max red count)
  | _ -> raise Not_found

let get_round_count = List.fold_left max_across_pulls (0, 0, 0)

let max_across_rounds (b1, g1, r1) (b2, g2, r2) =
  (Int.max b1 b2, Int.max g1 g2, Int.max r1 r2)

let get_counts (_, body) =
  List.map get_round_count body
  |> List.fold_left max_across_rounds (0, 0, 0)

let () = list
  |> List.map parse_line
  |> List.map get_counts
  |> List.map (fun (b, g, r) -> b * g * r)
  |> List.fold_left ( + ) 0
  |> Printf.printf "Solution 2: %d\n"
