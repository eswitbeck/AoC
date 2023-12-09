module String_map = Map.Make(String)

type input = {
  directions: char array;
  map: (string * string) String_map.t
}
 
let filename = "input"

let input = 
  let open Re.Pcre in
  let parse_map line =
    extract ~rex:(regexp "(.+) = \\((.+), (.+)\\)") line
    |> (fun a -> (a.(1), (a.(2), a.(3))))
  in
  let string_explode s = List.init (String.length s) (String.get s) in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n\n")
  |> (fun l ->
    { directions = string_explode @@ String.trim @@ List.hd l |> Array.of_list;
      map = split ~rex:(regexp "\n") @@ List.hd @@ List.tl l
        |> List.map parse_map 
        |> List.fold_left
             (fun m (a, b) -> String_map.add a b m)
             String_map.empty
    })

let get_directions dir i = 
  dir.(i mod (Array.length dir))

let follow_directions i (l, r) =
  match get_directions input.directions i with
  | 'L' -> l
  | 'R' -> r
  | _ -> failwith "Illegal argument"

let rec cascade_directions map key i = 
  match key with
  | "ZZZ" -> i
  | k -> let p = String_map.find k map in
    cascade_directions map (follow_directions i p) (i + 1)

let () =
  cascade_directions input.map "AAA" 0
  |> Printf.printf "Part 1 solution: %d\n"
