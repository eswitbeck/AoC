type universe = char array array
type galaxy_address = (int * int)

let universe_of_filename (filename : string) : universe =
  let explode_string s = List.init (String.length s) (String.get s) in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  read_file filename
  |> String.trim
  |> Re.Pcre.(split ~rex:(regexp "\n"))
  |> List.map explode_string
  |> List.map Array.of_list
  |> Array.of_list

let transpose_universe u =
  Array.init
    (Array.length u.(0))
    (fun i -> Array.init
      (Array.length u) 
      (fun j -> 
      u.(j).(i)))

let is_empty_row = Array.for_all (fun ch -> ch = '.')

let expand_universe (u : universe) : universe =
  let expand_all_rows u =
    let rec aux i l u =
      match i with 
      | i when i = Array.length u -> Array.of_list @@ List.rev l
      | i when is_empty_row u.(i) -> aux (i + 1) (u.(i)::u.(i)::l) u
      | i -> aux (i + 1) (u.(i)::l) u
    in
    aux 0 [] u
  in
  u
  |> transpose_universe
  |> expand_all_rows
  |> transpose_universe
  |> expand_all_rows  

let get_galaxies (u : universe) : galaxy_address list = 
  u |> Array.to_list |> List.map Array.to_list
  |> List.mapi (fun i r -> 
    List.mapi (fun j ch -> if ch = '#' then (i, j) else (-1, -1)) r)
  |> List.flatten
  |> List.filter (fun (i, _) -> i <> -1)

let get_all_distances (gas : galaxy_address list) : int list =
  let get_dist (a, b) (c, d) = 
    let mag1 = d - b in
    let mag2 = c - a in
    (if mag1 < 0 then -mag1 else mag1) + (if mag2 < 0 then -mag2 else mag2)
  in
  let rec aux dists = function
    | [] -> dists
    | hd::tl ->
      let curr_dists = List.map (get_dist hd) tl in
      aux (curr_dists::dists) tl
  in
  aux [] gas |> List.flatten
  
let filename = "input"

let input = universe_of_filename filename

let () = 
  input
  |> expand_universe
  |> get_galaxies
  |> get_all_distances 
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 1 solution: %d\n"

let get_row_gaps (u : universe) : int array =
  let rec aux l count = function
    | i when i = Array.length u -> Array.of_list @@ List.rev l
    | i when is_empty_row u.(i) -> aux ((count + 1)::l) (count + 1) (i + 1)
    | i -> aux (count::l) count (i + 1)
  in
  aux [] 0 0

let expand_get_all_distances (rgs : int array) (cgs : int array) (gas : galaxy_address list): int list =
  let get_dist (a, b) (c, d) = 
    let mult = 1000000 in
    let mag1 = if d > b then d - b else b - d in
    let mag2 = if c > a then c - a else a - c in
    let c_gaps = if cgs.(d) > cgs.(b) then cgs.(d) - cgs.(b) else cgs.(b) - cgs.(d) in
    let r_gaps = if rgs.(c) > rgs.(a) then rgs.(c) - rgs.(a) else rgs.(a) - rgs.(c) in
    mag1 + c_gaps * (mult - 1) + mag2 + r_gaps * (mult - 1)
  in
  let rec aux dists = function
    | [] -> dists
    | hd::tl ->
      let curr_dists = List.map (get_dist hd) tl in
      aux (curr_dists::dists) tl
  in
  aux [] gas |> List.flatten

let () =
  let row_gaps = get_row_gaps input in
  let column_gaps = get_row_gaps @@ transpose_universe input in
  input
  |> get_galaxies
  |> expand_get_all_distances row_gaps column_gaps
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 2 solution: %d\n"
