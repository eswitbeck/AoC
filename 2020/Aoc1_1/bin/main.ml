let filename = "input1"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = read_file file in
  String.split_on_char '\n' contents

let list = 
  let rec trim_last file = 
    match file with
    | [] -> []
    | _::[] -> []
    | a::b -> a :: trim_last b in
  let lines = read_lines filename in
  trim_last lines 

let adapt list =
  let l = 
    List.map int_of_string list in
  let asc_sort a b = a - b in
  List.sort asc_sort l

let input = adapt list

let target = 2020

let rec two_sum l i j target =
  if j < 0 then (-1, -1)
  else if l = [] then (-1, -1)
  else
  let first = List.nth l i in
  let second = List.nth l j in
  let sum = first + second in
  if sum = target then (first, second)
  else if sum > target then two_sum l i (j - 1) target
  else two_sum l (i + 1) j target

let solution_1 =
  let len = List.length input - 1 in
  let (x, y) = two_sum input 0 len target in
  x * y

let rec three_sum l target =
  match l with
  | [] -> (-1, -1, -1)
  | _::[] -> (-1, -1, -1)
  | a::b ->
      let remaining = target - a in
      let len = List.length b - 1 in
      let (x, y) = two_sum b 0 len remaining in
      if x <> -1 && x + y = remaining then (a, x, y)
      else three_sum b target

let solution_2 = 
  let (x, y, z) = three_sum input target in
  x * y * z

let () = 
  Printf.printf "%d\n%d\n" solution_1 solution_2
