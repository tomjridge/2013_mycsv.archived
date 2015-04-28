
open P1_lib
open P1_cl
open Mycsv_lib

type ty_cl_args = { filename1:string; width1:ty_width; sep1:string; outsep1:string; dquote1:string; fields1:string }
let cl0 = { filename1="-"; width1=MaxNoQuote1; sep1="|"; outsep1="|"; dquote1="\""; fields1="" } 

let listof = P1_extra_combinators.listof

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
        | ("-fields",[a]) -> {cl with fields1=a }
        | ("-f",[a]) -> {cl with filename1=a }
        | _ -> (failwith ("parse_CL: unrecognized flag/arg combination: "^f^" "^(String.concat " " xs))))
    in
    let sep = a "\x00" in
    (((listof parse_FLARGS sep) **> parse_EOF) >> (fun (xs,_) -> List.fold_right f1 xs cl0))) i


(* copied from ocaml/utils/misc.ml *)
let string_of_ic' ic =
  let b = Buffer.create 0x10000 in
  let buff = String.create 0x1000 in
  let rec copy () =
    let n = input ic buff 0 0x1000 in
    if n = 0 then Buffer.contents b else
      (Buffer.add_substring b buff 0 n; copy())
  in copy()

let read_ic_as_string ic = (
  try
    string_of_ic' ic
  with _ -> failwith "read_ic_as_string")


let main =
  let args = get_args parse_CL Sys.argv in
  (* testing let args = { sep1="|"; outsep1="|"; width1=None1; filename1="/tmp/tmp.csv"; dquote1="\""; fields1="" } in *)
  let (sep,outsep,newline,dquote) = (args.sep1,args.outsep1,"\n",args.dquote1) in
  let fields = (
    match args.fields1 with 
    | "" -> None
    | _ -> (
        let parse_num = parse_RE "[0-9]+" in
        let p = ((listof (parse_num >> (fun x -> (int_of_string (content x)))) (a ",")) **> parse_EOF) >> (fun (x,y) -> x) in
        let fields = p (toinput (mk_ss args.fields1)) in
        match fields with
        | [] -> (failwith ("unable to parse fields: "^args.fields1))
        | ((x,_)::_) -> Some(x)))
  in
  let params = { sep=sep; outsep=outsep; newline=newline; dquote=dquote; fields=fields } in
  let s = (match args.filename1 with
      | "-" -> (read_ic_as_string stdin)
      | _ -> (match read_file_as_string args.filename1 with | Some s -> s | _ -> (failwith "mycsv:59"))) 
  in
  let rs = parse_string params s in
  let rs = (match rs with 
      | `Result rs -> rs
      | _ -> (failwith ("Error parsing file:"^args.filename1)))
  in  
  let w = max_width rs in
  let _ = List.map print_string (List.map (format_row params args.width1 w) rs) in
  ()
