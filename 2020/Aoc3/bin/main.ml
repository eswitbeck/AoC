let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents

let input = read_lines filename

let solution slope =
  let intersects (x,y) =
    let y_filtered = List.filteri (fun i _ -> i mod y = 0) input in
    List.mapi (fun i row ->
      let index = x * i mod (String.length row) in
      row.[index]
    ) y_filtered
  in
  List.fold_left (fun count ch ->
    match ch with
    | '#' -> count + 1
    | _ -> count
  ) 0 (intersects slope)

let solution_1 = solution (3, 1)

let slopes = [(1, 1); (3, 1); (5, 1); (7, 1); (1, 2)]

let solution_2 =
  let totals = List.map solution slopes in
  List.fold_left (fun accum sum -> accum * sum) 1 totals

let () = 
  Printf.printf "%d\n" solution_1
let () = 
  Printf.printf "%d\n" solution_2
