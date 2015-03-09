(* functions built into the Lemon programming language *)
let rec cap i list =
    match (i, list) with
        | 0, h :: t -> []
        | _, [] -> list
        | _, h :: t -> h :: cap (i - 1) t
;;

let rec uniq l =
  let rec aux l n =
    match l with
    | [] -> []
    | h :: t -> if n = h then aux t n else h :: (aux t n)
    in match l with
         | [] -> []
         | h :: t -> h :: (aux (uniq t) h)
;;

let rec append list letter =
    match list with
    | [] -> []
    | h :: t -> List.sort compare ((h ^ letter) :: append t letter)
;;

let union set1 set2 =
    List.sort compare (uniq (List.merge compare set1 set2))
;;

let kleene _char limit =
    let rec aux str count =
        (str ^ _char) :: if count = limit then [] else aux (str ^ _char) (count + 1)
    in ":" :: (aux "" 2)
;;

(* functions used to swap between sets and list *)
let string_to_list s =
  let rec aux i list =
    if i < 0 then list else aux (i - 1) (s.[i] :: list) in
  aux (String.length s - 1) []
;;

let list_to_string l =
  let result = String.create (List.length l) in
  let rec aux count = function
  | [] -> result
  | c :: l -> String.set result count c; aux (count + 1) l in
  aux 0 l
;;

let rec cat l =
    match l with
        | [] -> []
        | ',' :: t -> []
        | '}' :: t -> []
        | ' ' :: t -> []
        | h :: t -> h :: (cat t)
;;

let findword l =
    list_to_string (cat l)
;;

let rec sublist i l =
    match (i, l) with
        | (_, []) -> []
        | (0, _) -> l
        | (_, h :: t) -> sublist (i - 1) t
;;

let rec compress l1 l2 =
    match l2 with
        | [] -> l1
        | '}' :: t -> l1
        | '{' :: t -> compress l1 t
        | ' ' :: t -> compress l1 t
        | ',' :: t -> compress l1 t
        | h :: t -> let w = findword l2 in compress (w :: l1) (sublist (String.length w) t)
;;

let set_to_list s =
    List.rev (compress [] (string_to_list s))
;;

(* removing colons *)
let remove_colon_from_list list =
    match list with
        | [] -> []
        | h :: t -> if (t = [':'])
                        then h :: []
                        else if (t = [])
                        then h :: t
                        else if h = ':' then t else h :: t
;;

let rec remove_colons list =
    match list with
        | [] -> []
        | h :: t -> list_to_string (remove_colon_from_list (string_to_list h)) :: remove_colons t
;;

let list_to_set list =
    let rec aux list =
        match list with
        | [] -> "}"
        | [x] -> x ^ "}"
        | h :: t ->  h ^ ", " ^ (aux t)
    in "{" ^ (aux list)
;;


(* utility functions *)
let rec remove_quotes_from_list l =
    match l with
    | [] -> []
    | h :: t -> if h = '\"' then remove_quotes_from_list t else h :: remove_quotes_from_list t
;;

let remove_quotes str = list_to_string (remove_quotes_from_list (string_to_list str));;


(* input reading functions *)
let line_stream_of_channel channel =
    Stream.from
      (fun _ ->
         try Some (input_line channel) with End_of_file -> None);;


exception EmptyList

let rec last_element = function
    | [x] -> x
    | _ :: t -> last_element t
    | [] -> raise EmptyList
;;

let remove_dollar_from_list list =
  match list with
    | [] -> []
    | h :: t -> t
;;

(* split token to get number *)
let remove_dollar str = list_to_string (remove_dollar_from_list (string_to_list str))
;;


let lines = line_stream_of_channel stdin;;

let get_line line_number =
    last_element (Stream.npeek (int_of_string (remove_dollar line_number)) lines)
;;

let get_last_line last_line =
    int_of_string (last_element (Stream.npeek last_line lines))
;;
