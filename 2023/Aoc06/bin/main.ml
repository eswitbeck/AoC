type race = {
  time : int;
  record_distance : int
}

type wins = int

let filename = "input"

let races_of_input_part_1 (filename : string) : race list =
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n")
  |> List.map @@ split ~rex:(regexp ".*:\\s*")
  |> List.map (fun l -> List.nth l 1)
  |> List.map @@ split ~rex:(regexp "\\s+")
  |> (fun l -> List.map2 (fun a b -> 
    { time = int_of_string a;
      record_distance = int_of_string b
    }) (List.nth l 0) (List.nth l 1))

let races_of_input_part_2 (filename : string) : race list =
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n")
  |> List.map @@ split ~rex:(regexp ".*:\\s*")
  |> List.map (fun l -> List.nth l 1)
  |> List.map @@ split ~rex:(regexp "\\s+")
  |> List.map @@ List.fold_left ( ^ ) ""
  |> List.map @@ (fun l -> [l])
  |> (fun l -> List.map2 (fun a b -> 
    { time = int_of_string a;
      record_distance = int_of_string b
    }) (List.nth l 0) (List.nth l 1))

(* better structure would be: pairs_of_input |> races_of_pairs *)

let wins_of_race (r : race) : wins =
  let rec helper (wins: wins) (secs: int) : wins = match secs with 
    | s when s > r.time -> wins
    | s -> let accel = s in
      let dist = accel * (r.time - s) in
      if dist > r.record_distance then
        helper (wins + 1) (secs + 1)
      else
        helper wins (secs + 1) in
  helper 0 0

let () =
  filename
  |> races_of_input_part_1
  |> List.map wins_of_race
  |> List.fold_left ( * ) 1
  |> Printf.printf "Solution 1: %d\n"

let () =
  filename
  |> races_of_input_part_2
  |> List.map wins_of_race
  |> List.fold_left ( * ) 1
  |> Printf.printf "Solution 2: %d\n"
