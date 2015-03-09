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

val eval : expr -> expr

val print_result : expr -> unit
