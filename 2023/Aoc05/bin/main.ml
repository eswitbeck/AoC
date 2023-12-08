type mapping = {
  destination: int;
  source: int;
  range: int
}

type map = mapping list

type input_data = {
  seeds: int list;
  maps: map list;
}

let parse_input (filename : string) : input_data =
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all
  in
  let chunks = filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n\n")
  in
  let seeds = List.hd chunks in
  let maps = List.tl chunks in
  let parse_seeds (seed_chunk : string) : int list =
    List.tl @@ split ~rex:(regexp "\\s+") seed_chunk
    |> List.map int_of_string
  in
  let parse_map (map_chunk : string) : map =
    List.tl @@ split ~rex:(regexp "\n") map_chunk
    |> List.map @@ extract ~rex:(regexp "(\\d+) (\\d+) (\\d+)")
    |> List.map @@ (fun a -> {
      destination = int_of_string a.(1);
      source = int_of_string a.(2);
      range = int_of_string a.(3)
    })
  in
  { seeds = parse_seeds seeds;
    maps = List.map parse_map maps }

let apply_map (source : int) (map : map) =
  let in_range i m = i >= m.source && i < m.source + m.range in
  match List.find_opt (in_range source) map with
  | Some m -> source - m.source + m.destination
  | None -> source

let destination_of_seed (maps : map list) (seed : int) : int =
  List.fold_left apply_map seed maps

let filename = "input"

let (input : input_data) = parse_input filename

let () = 
  input.seeds
  |> List.map @@ destination_of_seed input.maps
  |> List.sort (fun a b -> a - b)
  |> List.hd
  |> Printf.printf "Part 1 solution: %d\n"

let spread_seeds (seeds : int list) =
  let rec pairs_of_seeds = function
    | [] -> []
    | a::b::tl -> (a, a + b - 1)::(pairs_of_seeds tl)
    | _ -> failwith "Illegal argument"
  in
  seeds
  |> pairs_of_seeds

let apply_map_2 (source : int) (map : map) =
  let in_range i m = i >= m.destination && i < m.destination + m.range in
  match List.find_opt (in_range source) map with
  | Some m -> source - m.destination + m.source
  | None -> source

let destination_of_seed_2 (maps : map list) (seed : int) : int =
  List.fold_left apply_map_2 seed maps

let find_lowest_in_range (pairs : (int * int) list) : int =
  let rec aux j =
    let source = destination_of_seed_2 (List.rev input.maps) j in
    let in_range i pair = i >= fst pair && i <= snd pair in
    match List.find_opt (in_range source) pairs with
    | Some _ -> j
    | None -> aux (j + 1)
  in
  aux 0

let () =
  input.seeds
  |> spread_seeds
  |> find_lowest_in_range
  |> Printf.printf "Part 2 solution: %d\n"
