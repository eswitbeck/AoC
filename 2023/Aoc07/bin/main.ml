type hand = (char * int) list

type submission = {
  sorted_hand : hand;
  bid: int;
  original_hand: char list
}

let filename = "input"

let pairs_of_input (filename : string) : (string * int) list =
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n")
  |> List.map @@ extract ~rex:(regexp "(.{5}) (\\d+)")
  |> List.map (fun arr -> (arr.(1), int_of_string arr.(2)))

let submission_of_pair (pair: string * int) : submission =
  let unprocessed_card = fst pair in
  let explode_string s = List.init (String.length s) (String.get s) in
  let module Char_map = Map.Make(Char) in
  let map_updater = function
  | Some i -> Some (i + 1)
  | None -> Some 1 in
  unprocessed_card
  |> explode_string
  |> List.fold_left (fun acc c -> Char_map.update c map_updater acc) Char_map.empty
  |> Char_map.bindings
  |> List.sort (fun a b -> (snd b) - (snd a))
  |> (fun l ->
  { sorted_hand = l;
    bid = snd pair;
    original_hand = explode_string @@ fst pair})

let card_comparator = function
  | x, y when x = y -> 0
  | 'A', _ -> 1
  | _ , 'A' -> -1
  | 'K', _ -> 1
  | _, 'K' -> -1
  | 'Q', _ -> 1
  | _, 'Q' -> -1
  | 'J', _ -> 1
  | _, 'J' -> -1
  | 'T', _ -> 1
  | _, 'T' -> -1
  | x, y -> int_of_string (Char.escaped x) - int_of_string (Char.escaped y)

let submission_comparator card_comparator (x : submission) (y : submission) : int =
  let rec original_hand_helper (a : char list) (b : char list) : int = 
    match a, b with
    | [], [] -> 0
    | _, [] -> 1
    | [], _ -> -1
    | a::b, c::d -> match card_comparator (a, c) with
      | 0 -> original_hand_helper b d
      | n -> n in
  let rec sorted_hand_helper = function
    | [], [] -> original_hand_helper x.original_hand y.original_hand
    | _, [] -> 1
    | [], _ -> -1
    | a::b, c::d -> 
      match snd a, snd c with
      | i, j when i < j -> -1
      | i, j when i > j -> 1
      | _, _ -> sorted_hand_helper (b, d) in
  sorted_hand_helper (x.sorted_hand, y.sorted_hand)

let add_jokers (_, n) (card, count) =
  (card, count + n)

let update_sorted_hand hand =
  match hand with 
  | [] -> []
  | a::b -> 
  let first = ref a in
  if fst !first = 'J' then
    match b with
    | [] -> hand
    | hd::tl -> (add_jokers !first hd)::tl
  else
    let rec scan_for_jokers = function
      | [] -> []
      | hd::tl when fst hd = 'J' -> first := add_jokers hd !first; tl
      | hd::tl -> hd::(scan_for_jokers tl) in
    !first::(scan_for_jokers b)

let update_submission s =
  { sorted_hand = (update_sorted_hand s.sorted_hand);
    bid = s.bid;
    original_hand = s.original_hand }
    
let card_comparator_2 = function
  | x, y when x = y -> 0
  | 'A', _ -> 1
  | _ , 'A' -> -1
  | 'K', _ -> 1
  | _, 'K' -> -1
  | 'Q', _ -> 1
  | _, 'Q' -> -1
  | 'T', _ -> 1
  | _, 'T' -> -1
  | _, 'J' -> 1
  | 'J', _ -> -1
  | x, y -> int_of_string (Char.escaped x) - int_of_string (Char.escaped y)

let submissions =
  filename
  |> pairs_of_input
  |> List.map submission_of_pair

let () =
  submissions
  |> List.sort @@ submission_comparator card_comparator
  |> List.mapi (fun i a -> (i + 1) * a.bid)
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 1 solution: %d\n"

let () =
  submissions
  |> List.map update_submission
  |> List.sort @@ submission_comparator card_comparator_2
  |> List.mapi (fun i a -> (i + 1) * a.bid)
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 2 solution: %d\n"
