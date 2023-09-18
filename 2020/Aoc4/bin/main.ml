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

type bool_passport = {
  mutable byr: bool;
  mutable iyr: bool;
  mutable eyr: bool;
  mutable hgt: bool;
  mutable hcl: bool;
  mutable ecl: bool;
  mutable pid: bool;
  mutable cid: bool;
}

let is_valid_passport p =
  p.byr && p.iyr &&
  p.eyr && p.hgt &&
  p.hcl && p.ecl &&
  p.pid

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

let to_field_passport bundle =
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
  let update (k, v) =
  let open Re in
  match k with
    | "byr" -> let year = int_of_string v in
      let result = year >= 1920 && year <= 2002 in
      passport.byr <- result
    | "iyr" -> let year = int_of_string v in
      let result = year >= 2010 && year <= 2020 in
      passport.iyr <- result
    | "eyr" -> let year = int_of_string v in
    let result = year >= 2020 && year <= 2030 in
      passport.eyr <- result
    | "hgt" -> let reg = Pcre.regexp "(\\d+)(cm|in)" in
      if Pcre.pmatch ~rex:reg v then
      let h = Pcre.extract ~rex:reg v in
      let height = int_of_string h.(1) in
      let u = h.(2) in
      let in_range height un =
      match un with 
        | "in" -> height >= 59 && height <= 76;
        | "cm" -> height >= 150 && height <= 193
        | _ -> raise Not_found in
      passport.hgt <- in_range height u
     else passport.hgt <- false
    | "hcl" -> let result = Pcre.pmatch ~rex:(Pcre.regexp "#([a-f0-9]){6}") v in
      passport.hcl <- result && String.length v = 7
    | "ecl" -> passport.ecl <- let options = "(amb|blu|brn|brn|gry|grn|hzl|oth)" in
      Pcre.pmatch ~rex:(Pcre.regexp options) v
    | "pid" -> let result = Pcre.pmatch ~rex:(Pcre.regexp "\\d{9}") v in
      passport.pid <- result && String.length v = 9
    | "cid" -> passport.cid <- true 
    | _ -> raise Not_found in
  List.iter update bundle;
  passport

let bool_passports = read_lines filename
  |> List.map extract_key_value_pairs
  |> List.map to_bool_passport

let field_passports = read_lines filename
  |> List.map extract_key_value_pairs
  |> List.map to_field_passport

let () = 
  List.filter is_valid_passport bool_passports
    |> List.length
    |> Printf.printf "1) Number of valid passports is: %d.\n"

let () = 
  List.filter is_valid_passport field_passports
    |> List.length
    |> Printf.printf "2) Number of valid passports is: %d.\n"

