

let (* *)
  let open Re.Pcre in
  let read_file filename =
    In_channel.with_open_bin filename In_channel.input_all in
  filename
  |> read_file
  |> String.trim
  |> split ~rex:(regexp "\n")
  
(* convert each list to a brick of cubes *)

(* create lookup class/assign each cube to it
   each cube points to owner brick *)

(* sort bricks by min brick *)

(* drop all cubes in order until
  any brick intersects an existing point in the lookup,
  updating lookup after *)

(* sort new bricks by min point *)

(* iterate through all sorted bricks:
   count points of contact above
   doubly linking the two bricks
   (all bricks should have above list and below list *)

(* from top down (reverse sorted bricks),
  check each above and confirm their belows are > 1
  |> length *)


let filename = "input"


