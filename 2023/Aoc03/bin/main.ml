let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let contents = String.trim (read_file file) in
  String.split_on_char '\n' contents
  |> Array.of_list
  |> Array.map (fun l -> Array.init (String.length l) (String.get l))

let matrix = read_lines filename

let touches_symbol i j arr =
  let directions = [-1; 0; 1] in
  let directional_vectors = 
    List.map (fun d1 -> List.map (fun d2 -> (d1, d2)) directions) directions
      |> List.flatten in
   directional_vectors
    |> List.map (fun (x1, y1) -> 
      let x2 = j + x1 in
      let y2 = i + y1 in
      (y2 >= 0 && y2 < Array.length arr) &&
      (x2 >= 0 && x2 < Array.length arr.(0)) &&
      Re.Pcre.pmatch ~rex:(Re.Pcre.regexp "[^\\d\\.]") (Char.escaped arr.(y2).(x2)))
     |> List.exists (fun a -> a)

let is_digit arr i j = Re.Pcre.pmatch ~rex:(Re.Pcre.regexp "\\d") (Char.escaped arr.(i).(j))

let convert_line_to_numbers full_arr i line =
  let rec helper numbers_list number_buffer touched j =
    let flush_buffer () = if String.length number_buffer <> 0 && touched
      then Some (int_of_string number_buffer)
      else None in
    if j = Array.length line then 
      match flush_buffer () with
        | Some n -> n::numbers_list
        | None -> numbers_list
    else if is_digit full_arr i j && touches_symbol i j full_arr then 
      helper numbers_list (number_buffer ^ (Char.escaped line.(j))) true (j + 1)
    else if is_digit full_arr i j  then (* digit but not touching; continue *)
      helper numbers_list (number_buffer ^ (Char.escaped line.(j))) touched (j + 1)
    else (* terminating case *)
      match flush_buffer () with
        | Some n -> helper (n::numbers_list) "" false (j + 1) 
        | None -> helper numbers_list "" false (j + 1) in
  helper [] "" false 0

let () = 
  matrix
    |> (fun a -> Array.mapi (convert_line_to_numbers a) a)
    |> Array.to_list
    |> List.flatten
    |> List.fold_left ( + ) 0
    |> Printf.printf "Part 1 solution: %d\n"

(* part 2: written a day later *)

let convert_matrix_to_piece_number_list matrix = 
  let get_valid_neighbors arr coord =
    let adjacent_vectors = 
      [(-1, -1); (-1, 0); (-1, 1);
       (0, -1);           (0, 1);
       (1, -1);  (1, 0);  (1, 1)] in
    let add_coords (a, b) (c, d) = (a + c, b + d) in
    let is_valid_coordinate arr (i, j) = 
      (i >= 0 && i < Array.length arr) &&
      (j >= 0 && j < Array.length arr.(0)) in
    adjacent_vectors
      |> List.map @@ add_coords coord 
      |> List.filter @@ is_valid_coordinate arr in
  let is_number arr (y, x) =
    let open Re.Pcre in
    pmatch ~rex:(regexp "\\d+") arr.(y).(x) in
  let remove_duplicates = List.sort_uniq ( - ) in
  let is_piece arr (y, x) = 
    let open Re.Pcre in
    pmatch ~rex:(regexp "[^\\d\\.]") arr.(y).(x) in
  let coord_matrix = matrix 
    |> Array.mapi @@ fun i r -> Array.mapi (fun j _ -> (i, j)) r in
  coord_matrix
    |> Array.to_list
    |> List.map Array.to_list
    |> List.flatten
    |> List.filter @@ is_piece matrix
    |> List.map @@ get_valid_neighbors coord_matrix
    |> List.map @@ List.filter @@ is_number matrix
    |> List.map @@ List.map (fun (y, x) -> int_of_string matrix.(y).(x))
    |> List.map remove_duplicates

let convert_piece_matrix_to_full_numbers matrix =
  let matrix_copy = Array.map (Array.map @@ fun a -> a) matrix
    |> Array.map @@ Array.map Char.escaped in
  let rec row_helper matrix number_buffer i j =
    let n = Array.length matrix.(0) in
    let flush_buffer () = if String.length number_buffer <> 0
      then Some number_buffer
      else None in
    match j with
    | j when j = n -> 
      begin
      match flush_buffer () with
      | Some num -> let len = n - 1 in
        for x = j - String.length num to len do
          matrix.(i).(x) <- num
        done
      | None -> ()
      end
    | _ -> let open Re.Pcre in
      if pmatch ~rex:(regexp "\\d+") matrix.(i).(j) then
        row_helper matrix (number_buffer ^ matrix.(i).(j)) i (j + 1)
      else 
        match flush_buffer() with
          | Some num -> for x = j - String.length num to j - 1 do
                matrix.(i).(x) <- num
              done;
              row_helper matrix "" i (j + 1)
          | None -> row_helper matrix number_buffer i (j + 1) in
  matrix_copy
    |> Array.iteri (fun i _ -> row_helper matrix_copy "" i 0);
  matrix_copy
      
let () =
  matrix
    |> convert_piece_matrix_to_full_numbers
    |> convert_matrix_to_piece_number_list
    |> List.filter (fun l -> List.length l = 2)
    |> List.map @@ List.fold_left ( * ) 1
    |> List.fold_left ( + ) 0
    |> Printf.printf "Part 2 solution: %d\n"
