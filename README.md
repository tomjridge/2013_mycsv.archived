# mycsv

A little tool to parse and format csv data. I use it often from within
emacs (via shell-command-on-region).

# Todo

  [ ] if a value is in a col which has quoted values, don't include length of quoted values when padding

  [ ] don't pad last column with whitespace!!!

  [ ] if a value is quoted and we are using MaxNoQuote, then that value should not contribute to the max for the col (the semantics of max should be "max non-quoted", since we are basically not interested in fiddling with quoted vals)

  [ ] add an option to not pad certain columns, or not pad a column if it will be quoted (doesn't make sense for layout reasons, probably) FIXME or should this just be if the value has a record separator (or a newline?)

  [ ] add an option to always quote

  [ ] add an option to select order of output columns (and which columns to output)
  
  [ ] change read file to read the bytes as chars (so we don't have to mess around with inserting \n between and at end etc)

  [ ] FIXME option trim doesn't seem to remove trailing ws from a quoted entry as last field in a record (it does - but ws is defined as spaces, not returns, so trimmed ws starts/ends at return)

  [ ] would like an option to sort by a particular column
  
  [ ] add an option to base64 encode values which need to be quoted; this should add a base64: prefix; add an option to unencode these values; useful for sorting lines (a multi-line csv value can be represented as a string with no line breaks)

  [ ] add an option to only output some fields; at the moment this isn't correct because it prints unwanted fields as empty strings, but they still have field separators; we should omit the entry altogether

  [ ] move away from .sh script files

  [ ] make pretty-printing more systematic - print_field; print_record etc

  http://www.codecodex.com/wiki/Read_a_file_into_a_byte_array (but only upto max_int bytes)

  http://rosettacode.org/wiki/Read_entire_file#OCaml


  [ ] make it possible to have separators like "->" - adjust command line parsing

  [ ] add a simple test suite

  [ ] add to p3 source, and popularize

