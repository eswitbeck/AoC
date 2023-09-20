let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let list = read_lines filename

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n -> 
    let b = pow a (n / 2) in
    b * b * (if n mod 2 = 0 then 1 else a)

let number_row i c =
  let index = i + 1 in
  let num = 128 / (pow 2 index) in
  let value = match c with
  | 'F' -> num * 0
  | 'B' -> num * 1
  | _ -> raise Not_found in
  value

let number_col i c =
  let index = i + 1 in
  let num = 8 / (pow 2 index) in
  let value = match c with
  | 'L' -> num * 0
  | 'R' -> num * 1
  | _ -> raise Not_found in
  value

let row_to_sum row = 
  let explode_string s = List.init (String.length s) (String.get s) in
  let first_seven = String.sub row 0 7
  |> explode_string 
  |> List.mapi number_row
  |> List.fold_left (fun acc a -> acc + a) 0 in
  let last_three = String.sub row 7 3
  |> explode_string
  |> List.mapi number_col
  |> List.fold_left (fun acc a -> acc + a) 0 in
  first_seven * 8 + last_three

let rec max acc list = 
  match list with
  | [] -> acc
  | hd::tl -> if hd > acc then max hd tl else max acc tl

let () = 
  list
  |> List.map row_to_sum
  |> max 0
  |> Printf.printf "Max seat ID is: %d.\n" 

let rec find_consecutive l = 
  match l with
  | a::b::c -> if b - a = 2 then b - 1 else find_consecutive (b::c)
  | [] | _::[] -> -1

let () =
  list
  |> List.map row_to_sum
  |> List.sort (fun a b -> a - b)
  |> find_consecutive
  |> Printf.printf "Your seat ID is: %d.\n"
