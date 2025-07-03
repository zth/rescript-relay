let contains s1 s2 =
  try
    ignore (Str.search_forward (Str.regexp_string s2) s1 0);
    true
  with Not_found -> false

let extractResolverParts text =
  (* Join all lines into a single string *)
  let text = String.concat " " (Str.split (Str.regexp "[\r\n]+") text) in
  (* Define the regular expression *)
  let re = Str.regexp ".*@RelayResolver \\([^\\.]+\\)\\.\\([^(:]+\\).*:.*" in
  if Str.string_match re text 0 then
    let part1 = Str.matched_group 1 text in
    let part2 = Str.matched_group 2 text in
    Some (part1, part2)
  else None

open Ppxlib
open Ast_helper

let extractRelayDocBlockComment (attributes : Parsetree.attributes) =
  attributes
  |> List.find_map (fun (a : Parsetree.attribute) ->
         match a with
         | {
          attr_name = {txt = "res.doc"};
          attr_payload =
            PStr
              [
                {
                  pstr_desc =
                    Pstr_eval
                      ({pexp_desc = Pexp_constant (Pconst_string (s, _, _))}, _);
                };
              ];
         }
           when contains s "@RelayResolver" ->
           Some s
         | _ -> None)

class mapper =
  object (self)
    inherit Ast_traverse.map
    method! structure_item structure_item =
      match structure_item.pstr_desc with
      | Pstr_value
          ( recFlag,
            [
              ({
                 pvb_attributes;
                 pvb_pat =
                   {ppat_attributes; ppat_desc = Ppat_var pat_var} as pat;
               } as valueBinding);
            ] )
        when extractRelayDocBlockComment pvb_attributes |> Option.is_some -> (
        let docBlockComment =
          extractRelayDocBlockComment pvb_attributes |> Option.get
        in
        match extractResolverParts docBlockComment with
        | Some (m, path) ->
          if pat_var.txt <> path then
            Ppxlib.Location.raise_errorf ~loc:pat_var.loc
              {|Function name must match the field name defined in the Relay Resolver docblock.

Rename this let binding to '%s' to fix this.|}
              path;
          {
            structure_item with
            pstr_desc =
              Pstr_value
                ( recFlag,
                  [
                    {
                      valueBinding with
                      pvb_pat =
                        {
                          pat with
                          ppat_desc =
                            Ppat_constraint
                              ( pat,
                                Typ.constr ~loc:pat_var.loc
                                  (Loc.make ~loc:pat_var.loc
                                     (Longident.parse
                                        (Printf.sprintf
                                           "%s_relayResolvers_graphql.%sResolver"
                                           m path)))
                                  [] );
                        };
                    };
                  ] );
          }
        | None -> structure_item)
      | _ -> structure_item
  end

let structure_mapper s = (new mapper)#structure s
