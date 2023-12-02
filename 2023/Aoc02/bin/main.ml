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

let () = list
  |> List.map parse_line
  |> List.fold_left
      (fun acc (game_number, body) -> 
        Printf.printf "%d: \n" game_number;
        List.iter (List.iter (fun (n, g_t) -> Printf.printf "%s %d\n" g_t n)) body;
        acc) 
      0
  |> (Printf.printf "%d")
      
