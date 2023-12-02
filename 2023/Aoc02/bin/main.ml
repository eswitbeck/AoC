let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let list = read_lines filename

let parse_line l = 
  let open Re.Pcre in 
  let split_line = extract ~rex:(regexp "Game (\\d+): (.*)") l in
  let game_number = int_of_string split_line.(1) in
  let split_body = split ~rex:(regexp "; ") split_line.(2) in
  let extract_pull pull = 
    let results = extract ~rex:(regexp "(\\d+) (blue|red|green)") pull in
    (int_of_string results.(1), results.(2)) in
  (
    game_number,
    split_body 
      |> List.map (split ~rex:(regexp ", "))
      |> List.map @@ List.map extract_pull
  )

(* syntax is: games are made of rounds are made of pulls *)
let is_valid_game (_ , body) = 
  let is_valid_pull (count, color) =
    match color with
    | "blue" -> count <= 14
    | "green" -> count <= 13
    | "red" -> count <= 12
    | _ -> raise Not_found in
  let is_valid_round = List.for_all is_valid_pull in
  List.map is_valid_round body
    |> List.for_all (fun a -> a)

let () = list
  |> List.map parse_line
  |> List.filter is_valid_game
  |> List.map fst
  |> List.fold_left ( + ) 0
  |> Printf.printf "Solution 1: %d\n"
      
let get_min_counts (_, body) =
  let max_across_pulls (blue, green, red) (count, color) =
    match color with
    | "blue" -> (Int.max blue count, green, red)
    | "green" -> (blue, Int.max green count, red)
    | "red" -> (blue, green, Int.max red count)
    | _ -> raise Not_found in 
  let get_round_count = List.fold_left max_across_pulls (0, 0, 0) in 
  let max_across_rounds (b1, g1, r1) (b2, g2, r2) =
    (Int.max b1 b2, Int.max g1 g2, Int.max r1 r2) in 
  List.map get_round_count body
    |> List.fold_left max_across_rounds (0, 0, 0)

let () = list
  |> List.map parse_line
  |> List.map get_min_counts
  |> List.map (fun (b, g, r) -> b * g * r)
  |> List.fold_left ( + ) 0
  |> Printf.printf "Solution 2: %d\n"
