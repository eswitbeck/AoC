let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let list = read_lines filename

module Int_set = Set.Make(Int)

(* game_number * set (int) * List int *)
let convert_to_card line =
  let open Re.Pcre in 
  let regex_base = ref "Card\\s*(\\d+):\\s*" in
  let rex =
  for _ = 0 to 9 do
    regex_base := !regex_base ^ "(?:(\\d+)\\s*)";
  done;
  regex_base := !regex_base ^ "\\|\\s*";
  for _ = 0 to 24 do
    regex_base := !regex_base ^ "(?:(\\d+)\\s*)";
  done;
  regexp !regex_base in
  let card = extract ~rex:rex line in
  let game_number = card.(1) in
  let winning_numbers = 
    let winning_numbers_array = Array.sub card 2 10 in
    Int_set.of_list (Array.to_list winning_numbers_array
    |> List.map int_of_string) in
  let card_numbers = Array.to_list @@ Array.sub card 12 25
  |> List.map int_of_string in
  (game_number, winning_numbers, card_numbers)

(* from https://stackoverflow.com/questions/16950687/integer-exponentiation-in-ocaml *)
let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n -> 
    let b = pow a (n / 2) in
    b * b * (if n mod 2 = 0 then 1 else a)

let score_card (_, w_n, c_n) =
  let number_of_matches =
    c_n
    |> List.filter (fun i -> Int_set.mem i w_n)
    |> List.length in
  match number_of_matches with
  | 0 -> 0
  | n -> pow 2 (n - 1)

let () =
  list
  |> List.map convert_to_card
  |> List.map score_card
  |> List.fold_left ( + ) 0
  |> Printf.printf "Part 1 solution: %d\n"

let update_count arr i n =
  for j = i + 1 to i + n do
    arr.(j) <- arr.(i) + arr.(j)
  done

let score_card2 (_, w_n, c_n) =
  c_n
  |> List.filter (fun i -> Int_set.mem i w_n)
  |> List.length

let () =
  let number_of_cards = Array.init (List.length list) (fun _ -> 1) in
  list
  |> List.map convert_to_card
  |> List.map score_card2
  |> List.iteri @@ update_count number_of_cards;
  number_of_cards
  |> Array.fold_left ( + ) 0
  |> Printf.printf "Part 2 solution: %d\n"
