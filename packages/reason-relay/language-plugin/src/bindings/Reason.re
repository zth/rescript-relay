type reasonAst;

[@bs.module "reason"] external parseRE: string => reasonAst = "";

[@bs.module "reason"] external printRE: reasonAst => string = "";