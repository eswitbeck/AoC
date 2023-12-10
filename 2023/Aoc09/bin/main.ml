let filename = "input"

let numbers_of_input filename=
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n")
  |> List.map @@ split ~rex:(regexp " ")
  |> List.map @@ List.map int_of_string

let input = numbers_of_input filename

let is_all_zeroes = List.for_all (fun n -> n = 0)

let get_deltas l =
  let rec aux list temp deltas =
    match list with
    | [] -> List.rev deltas
    | hd::tl -> aux tl hd ((hd - temp)::deltas)
  in
  aux (List.tl l) (List.hd l) []

let get_next_value l =
  let last l = List.nth l ((List.length l) - 1) in
  let rec aux last_elements = function
    | l when is_all_zeroes l -> List.fold_left ( + ) 0 last_elements
    | l -> aux ((last l)::last_elements) (get_deltas l)
  in
  aux [] l

let () =
  input
  |> List.map get_next_value
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 1 solution: %d\n"

let get_prior_value l =
  let first = List.hd in
  let rec aux first_elements = function
    | l when is_all_zeroes l -> List.fold_left (fun a b -> b - a) 0 first_elements
    | l -> aux ((first l)::first_elements) (get_deltas l)
  in
  aux [] l
 
let () =
  input
  |> List.map get_prior_value
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 2 solution: %d\n"
