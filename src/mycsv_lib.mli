    type ty_csv_params = {
      sep : string;
      outsep : string;
      dquote : string;
      newline : string;
      fields : int list option;
    }
    val default_params: ty_csv_params
    type ty_width = None1 | Some1 of int | Trim1 | Max1 | MaxNoQuote1
    val default_width: ty_width
    val parse_string: ty_csv_params -> string -> [ `No_parse of string | `Ambiguous of string | `Result of string list list ]
    val needs_quote : ty_csv_params -> string -> bool
    val quote : ty_csv_params -> string -> string
    val max_width : string list list -> (int -> int)
    val format_cell :
      ty_csv_params -> ty_width -> (int -> int) -> int * string -> string
    val format_row :
      ty_csv_params -> ty_width -> (int -> int) -> string list -> string
    val format_rows :
      ty_csv_params -> ty_width -> string list list -> string
