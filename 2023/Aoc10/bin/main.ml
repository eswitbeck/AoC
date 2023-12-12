type symbol = char
type map = symbol list list
type coordinate = (int * int)
type direction = North | East | West | South
type openings = direction list
type node = {
  coordinate : coordinate;
  openings : openings;
  visited : bool
}

module String_map = Map.Make(String)

type input = {
  lookup : node String_map.t;
  start : coordinate;
  map : map
}

let openings_of_symbol = function
  | '|' -> [North; South]
  | '-' -> [East; West]
  | 'L' -> [North; East]
  | 'J' -> [North; West]
  | '7' -> [South; West]
  | 'F' -> [South; East]
  | '.' -> []
  | 'S' -> [North; South; East; West]
  | _ -> failwith "Illegal symbol"

let move_direction (coord : coordinate) (dir : direction) : coordinate =
  match dir with
  | North -> (fst coord, snd coord - 1)
  | South -> (fst coord, snd coord + 1)
  | East -> (fst coord + 1, snd coord)
  | West -> (fst coord - 1, snd coord)

let is_in_bounds (m : map) (coord : coordinate) : bool = 
  fst coord >= 0 && fst coord < (List.length @@ List.hd m) &&
  snd coord >= 0 && snd coord < (List.length m)

let is_reflexive (f: node) (t : node) =
  t.openings
  |> List.map @@ move_direction t.coordinate
  |> List.exists @@ (fun n c -> c = n.coordinate) f

let explode_string s = List.init (String.length s) (String.get s)

let map_of_filename (filename : string) : map =
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n")
  |> List.map @@ explode_string

let get_start (m : map) : coordinate =
  let rec aux (x : int) (y : int) (cols : symbol list) : coordinate =
    match cols with
    | [] -> (-1, -1)
    | (hd::_) when hd = 'S' -> (x, y)
    | (_::tl) -> aux (x + 1) y tl
  in
  List.mapi (aux 0) m
  |> List.filter @@ is_in_bounds m
  |> List.hd (* should always only return one element *)

let string_of_coordinate (c : coordinate) : string =
  Printf.sprintf "(%d, %d)" (fst c) (snd c)

let input_of_map (m : map) : input =
  let lookup = m 
    |> List.mapi (fun i r ->
      List.mapi (fun j c -> {
      coordinate = (j, i);
      openings = openings_of_symbol c;
      visited = false }) r)
    |> List.flatten
    |> List.fold_left (fun m n -> String_map.add (string_of_coordinate n.coordinate) n m) String_map.empty
  in 
  { map = m;
    start = get_start m;
    lookup = lookup }

let rec loop_length (i : input) (count : int) (n : node) : int =
  if n.visited
  then count
  else 
    let neighbors =
      n.openings
      |> List.map @@ move_direction n.coordinate
      |> List.filter @@ is_in_bounds i.map
      |> List.map string_of_coordinate
      |> List.map @@ (fun s -> String_map.find s i.lookup)
      |> List.filter @@ is_reflexive n
    in
    let updated_i = { i with lookup = String_map.add
      (string_of_coordinate n.coordinate)
      { n with visited = true }
      i.lookup
    } in
    match neighbors with
    | [] -> Int.min_int
    | ns -> List.map (loop_length updated_i (count + 1)) ns
      |> List.fold_left (fun a b -> Int.max a b) Int.min_int

let farthest_point (count : int) : int =
  if count mod 2 = 0
    then count / 2
    else (count + 1) / 2
  
let filename = "input"

let input = 
  filename
  |> map_of_filename
  |> input_of_map

let () =
  String_map.find (string_of_coordinate input.start) input.lookup
  |> loop_length input 0
  |> farthest_point
  |> Printf.printf "Part 1 solution: %d\n"
