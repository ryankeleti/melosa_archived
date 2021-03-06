open Sexplib.Std

type 'a t = {
  it : 'a;
  span : Span.t;
}
and exp = exp' t
and exp' =
  | Pexp_unit
  | Pexp_id of Lid.t
  | Pexp_const of const
  | Pexp_annot of exp * ty
  | Pexp_tuple of exp list
  | Pexp_cons of Lid.t * exp option
  | Pexp_if of exp * exp * exp
  | Pexp_match of exp * rule list
  | Pexp_lambda of pat list * exp
  | Pexp_app of exp * exp list
  | Pexp_let of bind list * exp 
  | Pexp_let_rec of bind list * exp 
  | Pexp_seq of exp * exp
and bind = bind' t
and bind' = { bind_pat : pat; bound : exp }
and rule = rule' t
and rule' = { rule_pat : pat; action : exp }

and pat = pat' t
and pat' =
  | Ppat_any
  | Ppat_unit
  | Ppat_var of Lid.t
  | Ppat_const of const
  | Ppat_tuple of pat list
  | Ppat_cons of Lid.t * pat option
  | Ppat_or of pat * pat

and ty = ty' t
and ty' =
  | Pty_any
  | Pty_var of string 
  | Pty_arrow of ty * ty
  | Pty_tuple of ty list
  | Pty_cons of Lid.t * ty option

and const =
  | Pconst_int of string
  | Pconst_bool of bool

and mexp = mexp' t
and mexp' =
  | Pmexp_id of Lid.t
  | Pmexp_annot of mexp * mty
  | Pmexp_str of structure
  | Pmexp_app of mexp * mexp
  | Pmexp_func of func_param * mexp
and func_param = { param_id : string; param_ty : mty }

and mty = mty' t
and mty' =
  | Pmty_id of Lid.t
  | Pmty_sig of signature
  | Pmty_func of func_param * mty

and ty_decl = ty_info list
and ty_info = ty_info' t
and ty_info' = { ty_id : string; kind : ty_kind; params : ty list option }
and ty_kind =
  | Pkind_abstract
  | Pkind_variant of ty_cons list
and ty_cons = ty_cons' t
and ty_cons' = { cons_id : string; cons_arg : ty option }

and mty_decl = mty_decl' t
and mty_decl' = { mty_id : string; mtype : mty option }

and signature = signature_item list
and signature_item = signature_item' t
and signature_item' =
  | Psig_val of string * ty
  | Psig_type of ty_decl
  | Psig_modtype of mty_decl
  | Psig_open of Lid.t
  | Psig_mod of string * mty

and structure = structure_item list
and structure_item = structure_item' t
and structure_item' =
  | Pstr_val of bind list
  | Pstr_val_rec of bind list
  | Pstr_type of ty_decl
  | Pstr_modtype of mty_decl
  | Pstr_exp of exp
  | Pstr_open of Lid.t
  | Pstr_mod of string * mexp
[@@deriving sexp_of, show { with_path = false }]

