open Printf
open Functions

type expr =
    | Var of string
    | Integer of int
    | Boolean of bool
    | Language of string
    | String of string
    | Sequence of expr * expr
    | PlusExpr of expr * expr
    | MinusExpr of expr * expr
    | LessThanExpr of expr * expr
    | GreaterThanExpr of expr * expr
    | EqualToExpr of expr * expr
    | StartExpr of expr * expr
    | IfExpr of expr * expr * expr
    | FuncExpr1 of string * string * expr * expr
    | FuncExpr2 of string * string * string * expr * expr
    | FuncExpr3 of string * string * string * string * expr * expr
    | VarExpr of string * expr * expr
    | AppExpr1 of expr * expr
    | AppExpr2 of expr * expr * expr
    | AppExpr3 of expr * expr * expr * expr
    | HeadExpr of expr
    | TailExpr of expr
    | AppendExpr of expr * expr
    | UnionExpr of expr * expr
    | ConsExpr of expr * expr
    | SizeExpr of expr
    | SortExpr of expr
    | UniqExpr of expr
    | CapExpr of expr * expr
    | KleeneExpr of expr * expr
    | ConcatExpr of expr * expr
    | LengthExpr of expr

let rec lookup env v = match env with
    | [] -> failwith ("cannot find var: " ^ v)
    | (vname, vvalue) :: rest -> if v = vname
                                     then vvalue
                                     else lookup rest v

let rec lookup2 env v  = match env with
   | [] -> failwith ("cannot find var: " ^ v)
   | (vname1, vvalue1) :: (vname2, vvalue2) :: rest -> if v = vname1
                                    then (vvalue1, vvalue2)
                                    else lookup2 rest v
   | (_, _) :: [] -> failwith ("cannot find var: " ^ v)


let rec lookup3 env v  = match env with
   | [] -> failwith ("cannot find var: " ^ v)
   | (vname1, vvalue1) :: (vname2, vvalue2) :: (vname3, vvalue3) :: rest -> if v = vname1
                                    then (vvalue1, vvalue2, vvalue3)
                                    else lookup3 rest v
   | (_, _) :: [] -> failwith ("cannot find var: " ^ v)
   | (_, _) :: (_, _) :: [] -> failwith ("cannot find var: " ^ v)

exception TypeErrorException
exception EmptyListException
exception UnrecognisedTypeException

let rec evaluator func_env arg_env term =
    let to_lang x =
        let xEval = evaluator func_env arg_env x
        in (match xEval with
              | Language x' -> x'
              | _ -> raise TypeErrorException)
        in let to_string x =
            let xEval = evaluator func_env arg_env x
            in (match xEval with
              | String x' -> x'
              | _ -> raise TypeErrorException)
        in let to_int x =
            let xEval = evaluator func_env arg_env x
            in (match xEval with
              | Integer x' -> x'
              | _ -> raise TypeErrorException)
    in match term with
        | (Var v) -> lookup arg_env v
        | (Integer i) -> Integer i
        | (Language l) -> Language l
        | (String c) -> String c
        | (Boolean b) -> Boolean b
        | (Sequence (a, b)) -> Sequence (a, b)
        | (PlusExpr (x, y) ) ->
            let x' = to_int x in
            let y' = to_int y in
                (Integer (x' + y'))
        | (MinusExpr (x, y) ) ->
            let x' = to_int x in
            let y' = to_int y in
                (Integer (x' - y'))
        | (LessThanExpr (x, y)) ->
            let x' = to_int x
            in let y' = to_int y
            in Boolean (x' < y')
        | (GreaterThanExpr (x, y)) ->
            let x' = to_int x
            in let y' = to_int y
            in Boolean (x' > y')
        | (EqualToExpr (x, y)) ->
            let x' = to_int x
            in let y' = to_int y
            in Boolean (x' = y')
        | (StartExpr (x, y)) ->
            (Sequence ((evaluator func_env arg_env x), (evaluator func_env arg_env y)))
        | (IfExpr (cond, trueExpr, falseExpr)) ->
            let condEval = evaluator func_env arg_env cond
            in (match condEval with
                  | (Boolean b) ->
                      evaluator func_env arg_env (if b then trueExpr else falseExpr)
                  | _ -> raise TypeErrorException)
        | (FuncExpr1 (name, argName, body, inExpr)) ->
            evaluator ((name, (argName, body)) :: func_env) arg_env inExpr
        | (FuncExpr2 (name, arg0Name, arg1Name, body, inExpr)) ->
            evaluator ((name, (arg0Name, body)) :: (name, (arg1Name, body)) :: func_env) arg_env inExpr
        | (FuncExpr3 (name, arg0Name, arg1Name, arg2Name, body, inExpr)) ->
            evaluator ((name, (arg0Name, body)) :: (name, (arg1Name, body)) :: (name, (arg2Name, body)) :: func_env) arg_env inExpr
        | (VarExpr (name, value, inExpr)) ->
            evaluator func_env ((name, (evaluator func_env arg_env value)) :: arg_env) inExpr
        | (AppExpr1 (func, arg)) ->
            let argEval = evaluator func_env arg_env arg
                in (match func with
                     | (Var f) ->
                        (match lookup func_env f with
                             | (argName, body) ->
                                evaluator func_env ((argName, argEval) :: arg_env) body)
                             | _ -> raise TypeErrorException)
         | (AppExpr2 (func, arg0, arg1)) ->
             let argEval0 = evaluator func_env arg_env arg0
             in let argEval1 = evaluator func_env arg_env arg1
                 in (match func with
                      | (Var f) ->
                         (match (lookup2 func_env f) with
                              | ((argName0, body0), (argName1, body1)) ->
                                 evaluator func_env ((argName0, argEval0) :: (argName1, argEval1) :: arg_env) body0)
                              | _ -> raise TypeErrorException)
          | (AppExpr3 (func, arg0, arg1, arg2)) ->
              let argEval0 = evaluator func_env arg_env arg0
              in let argEval1 = evaluator func_env arg_env arg1
              in let argEval2 = evaluator func_env arg_env arg2
                in (match func with
                       | (Var f) ->
                          (match (lookup3 func_env f) with
                               | ((argName0, body0), (argName1, body1), (argName2, body2)) ->
                                  evaluator func_env ((argName0, argEval0) :: (argName1, argEval1) :: (argName2, argEval2) :: arg_env) body0)
                               | _ -> raise TypeErrorException)
        | (HeadExpr x) ->
            let x' = set_to_list (to_lang x)
            in let head list =
                match list with
                | [] -> raise EmptyListException
                | h :: t -> "\"" ^ h ^ "\""
            in String (head x')
        | (TailExpr x) ->
            let x' = set_to_list (to_lang x)
            in let tail list =
                match list with
                | [] -> raise EmptyListException
                | h :: t -> t
            in Language (list_to_set (tail x'))
        | (AppendExpr (x, y)) ->
            let x' = set_to_list (to_lang x)
            in let y' = to_string y
            in Language (list_to_set (remove_colons (List.sort compare (uniq (append x' (remove_quotes y'))))))
        | (UnionExpr (x, y)) ->
            let x' = set_to_list (to_lang x)
            in let y' = set_to_list (to_lang y)
            in Language (list_to_set (List.sort compare (union x' y')))
        | (ConsExpr (x, y)) ->
            let x' = remove_quotes (to_string x)
            in Language (list_to_set (x' :: set_to_list (to_lang y)))
        | (SizeExpr x) ->
            Integer (List.length(set_to_list(to_lang x)))
        | (SortExpr x) ->
            Language (list_to_set (List.sort compare (set_to_list (to_lang x))))
        | (UniqExpr x) ->
            Language (list_to_set (uniq (set_to_list (to_lang x))))
        | (CapExpr (x, y)) ->
            let x' = (set_to_list (to_lang x))
            in let y' = to_int y
            in Language (list_to_set (cap y' x'))
        | (KleeneExpr (x, y)) ->
            let x' = (remove_quotes (to_string x))
            in let y' = to_int y
            in Language (list_to_set (remove_colons (List.sort compare (kleene x' y'))))
        | (ConcatExpr (x, y)) ->
            let x' = remove_quotes (to_string x)
            in let y' = remove_quotes (to_string y)
            in String (list_to_string (remove_colon_from_list (string_to_list (x' ^ y'))))
        | (LengthExpr x) ->
            (Integer (List.length (remove_quotes_from_list(string_to_list (to_string x)))))
;;

let eval term = evaluator [] [] term ;;

let rec print_result result = match result with
    | (Integer i) -> print_int i
    | (Language l) -> print_string l
    | (String s) -> print_string s
    | (Boolean b) -> if b then print_string "true" else print_string "false"
    | (Sequence (a, b)) -> print_result a; print_string "\n";print_result b
    | _ -> raise UnrecognisedTypeException
