#!/usr/bin/env ocamlscript

let _ = Ocaml.packs := ["unix"]

let _ = Ocaml.ocamlflags := ["-w"; "-1..100"]

(* for local versions *)
(*
let _ = Ocaml.sources := [
  "mycsv_resources.ml"; (* should be an empty file if using local versions *)
  "p3_lib.ml";
  "mycsv.ml";
]
*)

(* for distribution *)
let _ = Ocaml.sources := [
  "mycsv_resources.ml";
]

--


(*
## Command line

The following command line options are available:

  * `-w <something>   `:  width option (trim, pad, max, none etc)                       
  * `-sep <string>    `:  the field separator                                           
  * `-outsep <string> `:  the field separator to use when printing                      
  * `-dquote <string> `:  the double quote character (default `"\""` ie the usual dquote!)
  * `-f <string>      `:  the filename to parse; defaults to stdin                      

A description of the width options:

  * `-w maxnq `: all cell contents in a column are padded to the max length in that column, except if the cell value would be quoted (default)
  * `-w max   `: all cell contents in a column are padded to the max length in that column
  * `-w none  `: all cell contents are untouched
  * `-w <num> `: all cell contents are padded/truncated to length n
  * `-w trim  `: all cell contents have leading and trailing whitespace removed

*)

open Mycsv_resources
open P3_lib
open Everything
open BasicParsers
open Mycsv

type ty_cl_args = { filename1:string; width1:ty_width; sep1:string; outsep1:string; dquote1:string }
let cl0 = { filename1="-"; width1=MaxNoQuote1; sep1="|"; outsep1="|"; dquote1="\""} 

(* precedence to earlier args *)
let rec parse_CL = fun i -> (
  let f1 (f,xs) cl = (match (f,xs) with
    | ("-w",["trim"]) -> {cl with width1=Trim1 }
    | ("-w",["max"]) -> {cl with width1=Max1 }
    | ("-w",["maxnq"]) -> {cl with width1=MaxNoQuote1 }
    | ("-w",["none"]) -> {cl with width1=None1 }
    | ("-w",[a]) -> {cl with width1=Some1(int_of_string a) }
    | ("-sep",[a]) -> {cl with sep1=a }
    | ("-outsep",[a]) -> {cl with outsep1=a }
    | ("-dquote",[a]) -> {cl with dquote1=a }
    | ("-f",[a]) -> {cl with filename1=a }
    | _ -> (failwith ("parse_CL: unrecognized flag/arg combination: "^f^" "^(String.concat " " xs))))
  in
  let sep = a "\x00" in
  (((listof parse_FLARGS sep) **> parse_EOF) >> (fun (xs,_) -> itlist f1 xs cl0))) i


(*
## Main
*)

let main =
  let args = get_args parse_CL Sys.argv in
  (* testing let args = { sep1="|"; outsep1="|"; width1=None1; filename1="/tmp/tmp.csv" } in *)
  let (sep,outsep,newline,dquote) = (args.sep1,args.outsep1,"\n",args.dquote1) in
  let params = { sep=sep; outsep=outsep; newline=newline; dquote=dquote } in
  let ls = lines args.filename1 in
  let s = ((String.concat newline ls)^newline) in (* FIXME note problem with appending a newline to a file that didn't end in newline *)
  let rs = parse_file params (toinput (full s)) in
  let rs = (match rs with 
    | [] -> (failwith ("main: failed to parse file: "^args.filename1))
    | [(rs,_)] -> rs
    | _ -> (failwith ("main: failed to parse file unambiguously: "^args.filename1)))
  in  
  let _ = List.map print_string (List.map (format params args.width1 rs) rs) in
  ()

