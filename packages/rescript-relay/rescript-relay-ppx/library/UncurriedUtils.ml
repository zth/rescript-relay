let enabled = ref false

let arity_to_attributes ~loc arity : Parsetree.attribute list =
  [
    {
      attr_name = Location.mknoloc "res.arity";
      attr_payload =
        Parsetree.PStr
          [
            Ast_helper.Str.eval
              (Ast_helper.Exp.constant
                 (Pconst_integer (string_of_int arity, None)));
          ];
      attr_loc = loc;
    };
  ]

let uncurriedFun ~loc ~arity funExpr =
  Ast_helper.Exp.construct ~loc
    ~attrs:(arity_to_attributes ~loc arity)
    (Location.mknoloc (Longident.Lident "Function$"))
    (Some funExpr)

let encode_arity_string arity = "Has_arity" ^ string_of_int arity

let arityType ~loc arity =
  Ast_helper.Typ.variant ~loc
    [
      {
        prf_loc = loc;
        prf_attributes = [];
        prf_desc = Rtag ({txt = encode_arity_string arity; loc}, true, []);
      };
    ]
    Closed None

let uncurriedType ~loc ~arity tArg =
  let tArity = arityType ~loc arity in
  Ast_helper.Typ.constr ~loc {txt = Lident "function$"; loc} [tArg; tArity]

open Parsetree
open Ast_mapper

let wrapAsUncurriedFn ~arity item =
  match item.pstr_desc with
  | Pstr_value (a1, [({pvb_expr = {pexp_desc = Pexp_fun _} as fn} as outerV)])
    ->
    {
      item with
      pstr_desc =
        Pstr_value
          ( a1,
            [
              {
                outerV with
                (* TODO: Should we care about actually figuring out the arity? *)
                pvb_expr = uncurriedFun ~loc:outerV.pvb_loc ~arity fn;
              };
            ] );
    }
  | _ -> item

let uncurriedMapper =
  {
    default_mapper with
    typ =
      (fun mapper typ ->
        match typ.ptyp_desc with
        | Ptyp_arrow (_, t1, t2) ->
          uncurriedType ~loc:typ.ptyp_loc ~arity:1
            (default_mapper.typ mapper typ)
        | _ -> default_mapper.typ mapper typ);
    expr =
      (fun mapper expr ->
        match expr.pexp_desc with
        | Pexp_apply _ ->
          {
            (default_mapper.expr mapper expr) with
            pexp_attributes =
              {
                attr_name = Location.mknoloc "res.uapp";
                attr_payload = Parsetree.PStr [];
                attr_loc = expr.pexp_loc;
              }
              :: expr.pexp_attributes;
          }
        | _ -> default_mapper.expr mapper expr);
    structure =
      (fun mapper structure ->
        let handle_str_item item =
          match item.pstr_desc with
          | Pstr_value
              (a1, [({pvb_expr = {pexp_desc = Pexp_fun _} as fn} as outerV)]) ->
            {
              (default_mapper.structure_item mapper item) with
              pstr_desc =
                Pstr_value
                  ( a1,
                    [
                      {
                        outerV with
                        (* TODO: Should we care about actually figuring out the arity? *)
                        pvb_expr = uncurriedFun ~loc:outerV.pvb_loc ~arity:1 fn;
                      };
                    ] );
            }
          | _ -> default_mapper.structure_item mapper item
        in
        List.map handle_str_item structure);
  }

let mapStructureItem str =
  if !enabled then uncurriedMapper.structure_item uncurriedMapper str else str
