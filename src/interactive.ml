(* 

Interactive top-level directives

Via findlib:

    #use "topfind";;
    #require "unix";;
    #require "str";;
    #directory "src_ext/p1/build";;
    #load "p1.cma";;

    #mod_use "mycsv_lib.ml";;

*)


(* test


write following to /tmp/tmp.csv

SHEEKH|Faisal|BSCOSCO|fs130|129018133|XXX|fs130||0%|||
STRICKLAND|Gregory Iain|BSCOSCO|gis2|119009385|XXX|gis2||37%||47.5|63.5
BEWAS|Hardeep|BSCOSCG/Y|hb177|129014618|XXX|hb177||38%|41.4285714|72.5|
GOODING|Sian|BSCOSCO|sg373|129016458|XXX|sg373||0%|||
LAM|Siu Ting|BSCOWMJ|stl19|129022567|XXX|stl19||34%|50||50.5
ALLEN|Tevyn|BSCOSCG|ta182|129049467|XXX|ta182||34%|54.2857143|47.5|
QIAN|Xinyi|BSCOSCO|xq11|129016932|XXX|xq11||33%|44.2857143||56
ALI|Alamgir|BSCOSCO||129034605|XXX||alamgir ali|37%|40||70
SINGH|Alakhdeep|BSCOSCO/S||129032166|XXX||alakhdeep sing|17%|||50.5

SHEEKH|Faisal|BSCOSCO|fs130|129018133|XXX|fs130||0%|||
STRICKLAND|Gregory Iain|BSCOSCO|gis2|119009385|XXX|gis2||37%||47.5|63.5
BEWAS|Hardeep|BSCOSCG/Y|hb177|129014618|XXX|hb177||38%|41.4285714|72.5|
GOODING|Sian|BSCOSCO|sg373|129016458|XXX|sg373||0%|||
LAM|Siu Ting|BSCOWMJ|stl19|129022567|XXX|stl19||34%|50||50.5
ALLEN|Tevyn|BSCOSCG|ta182|129049467|XXX|ta182||34%|54.2857143|47.5|
QIAN|Xinyi|BSCOSCO|xq11|129016932|XXX|xq11||33%|44.2857143||56
ALI|Alamgir|BSCOSCO||129034605|XXX||alamgir ali|37%|40||70
SINGH|Alakhdeep|BSCOSCO/S||129032166|XXX||alakhdeep sing|17%|||50.5

open Mycsv_lib
let (Some tmps) = Tr_simple_file.read_string_from_file "/tmp/tmp.csv"
let params = { sep="|"; outsep="|"; dquote="\""; newline="\n"; fields=None }
let _ = parse_string params tmps

write following to /tmp/tmp.csv

SHEEKHabcFaisalabcBSCOSCOabcfs130abc129018133abcXXXabcfs130abcabc0%abcabcabc
STRICKLANDabcGregory IainabcBSCOSCOabcgis2abc119009385abcXXXabcgis2abcabc37%abcabc47.5abc63.5
BEWASabcHardeepabcBSCOSCG/Yabchb177abc129014618abcXXXabchb177abcabc38%abc41.4285714abc72.5abc
GOODINGabcSianabcBSCOSCOabcsg373abc129016458abcXXXabcsg373abcabc0%abcabcabc
LAMabcSiu TingabcBSCOWMJabcstl19abc129022567abcXXXabcstl19abcabc34%abc50abcabc50.5
ALLENabcTevynabcBSCOSCGabcta182abc129049467abcXXXabcta182abcabc34%abc54.2857143abc47.5abc
QIANabcXinyiabcBSCOSCOabcxq11abc129016932abcXXXabcxq11abcabc33%abc44.2857143abcabc56
ALIabcAlamgirabcBSCOSCOabcabc129034605abcXXXabcabcalamgir aliabc37%abc40abcabc70
SINGHabcAlakhdeepabcBSCOSCO/Sabcabc129032166abcXXXabcabcalakhdeep singabc17%abcabcabc50.5


let (Some tmps) = Tr_simple_file.read_string_from_file "/tmp/tmp.csv"
let params = { sep="abc"; outsep="|"; dquote="\""; newline="\n"; fields=None }
let _ = parse_string params tmps


--
SHEEKH|Faisal|BSCOSCO|fs130|129018133|XXX|fs130||0%|||
STRICKLAND|Gregory Iain|BSCOSCO|gis2|119009385|XXX|gis2||37%||47.5|63.5

STRICKLAND|Gregory Iain|BSCOSCO|gis2|119009385|XXX|gis2||37%||47.5|63.5
--

(* the above with the blank line at the end gives multiple parses; without blank line at end, we don't get multiple parses; problem is that parse file currently allows epsws at end, which can include return characters; solution is to remove epsws *)

let (Some tmps) = Tr_simple_file.read_string_from_file "/tmp/tmp.csv"
let params = { sep="|"; outsep="|"; dquote="\""; newline="\n"; fields=None }
let _ = parse_string params tmps



let f1 = "hello"
let f2 = "\"hello \"\" world\""
let f3 = "hello \n world"
let f4 = "\"hello \"\" \n world\""

let r1 = (String.concat params.sep [f1;f2])^params.newline
let r2 = (String.concat params.sep [f1;f2;f4])^params.newline

let _ = parse_plain_field (toinput (full f2))
let _ = parse_quoted_field (toinput (full f2))
let _ = parse_field (toinput (full f2))

let _ = parse_field (toinput (full f3))
let _ = parse_field (toinput (full f4))

let _ = parse_record (toinput (full r1))
let _ = parse_record (toinput (full r2))

let rs = longest parse_records (toinput (full ((String.concat newline lines)^newline)))


SHEEKH|Faisal|BSCOSCO|fs130|129018133|XXX|fs130||0%|||
STRICKLAND|Gregory Iain|BSCOSCO|gis2|119009385|XXX|gis2||37%||47.5|63.5
BEWAS|Hardeep|BSCOSCG/Y|hb177|129014618|XXX|hb177||38%|41.4285714|72.5|
GOODING|Sian|BSCOSCO|sg373|129016458|XXX|sg373||0%|||
LAM|Siu Ting|BSCOWMJ|stl19|129022567|XXX|stl19||34%|50||50.5
ALLEN|Tevyn|BSCOSCG|ta182|129049467|XXX|ta182||34%|54.2857143|47.5|
QIAN|Xinyi|BSCOSCO|xq11|129016932|XXX|xq11||33%|44.2857143||56
ALI|Alamgir|BSCOSCO||129034605|XXX||alamgir ali|37%|40||70
SINGH|Alakhdeep|BSCOSCO/S||129032166|XXX||alakhdeep sing|17%|||50.5


*)
