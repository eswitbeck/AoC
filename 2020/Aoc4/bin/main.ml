let filename = "input"

let read_file file =
  In_channel.with_open_bin file In_channel.input_all

let read_lines file =
  let open Re in
  let contents = String.trim (read_file file) in
  let double_line = Pcre.regexp "\n\n" in
  Pcre.split ~rex:double_line contents

let extract_key_value_pairs bundles = 
  let open Re in
  let spaces_and_newlines_regex = Pcre.regexp "[ |\n]" in
  let key_value_regex = Pcre.regexp "(.+):(.+)" in
  let arr = Pcre.split ~rex:spaces_and_newlines_regex bundles
    |> List.map (Pcre.extract ~rex:key_value_regex) in
  List.map (fun p -> (p.(1), p.(2))) arr

type passport = {
  mutable byr: bool;
  mutable iyr: bool;
  mutable eyr: bool;
  mutable hgt: bool;
  mutable hcl: bool;
  mutable ecl: bool;
  mutable pid: bool;
  mutable cid: bool;
}

let to_bool_passport bundle =
  let passport =  {
    byr = false;
    iyr = false;
    eyr = false;
    hgt = false;
    hcl = false;
    ecl = false;
    pid = false;
    cid = false;
  } in
  let update (f, _) =
  match f with
    | "byr" -> passport.byr <- true
    | "iyr" -> passport.iyr <- true
    | "eyr" -> passport.eyr <- true
    | "hgt" -> passport.hgt <- true
    | "hcl" -> passport.hcl <- true
    | "ecl" -> passport.ecl <- true
    | "pid" -> passport.pid <- true
    | "cid" -> passport.cid <- true 
    | _ -> raise Not_found in
  List.iter update bundle;
  passport

let is_valid_passport p =
  p.byr && p.iyr &&
  p.eyr && p.hgt &&
  p.hcl && p.ecl &&
  p.pid

let passports = read_lines filename
  |> List.map extract_key_value_pairs
  |> List.map to_bool_passport

let () = 
  List.filter is_valid_passport passports
    |> List.length
    |> Printf.printf "Number of valid passports is %d\n"
