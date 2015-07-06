{ }:
let 
  pkgs = import <nixpkgs> {};
  op = pkgs.ocamlPackages;
  inherit (pkgs) stdenv fetchgit ocaml;
  inherit (pkgs.ocamlPackages) findlib opam;
  p1 = import ../p1 { };
in
stdenv.mkDerivation {

      name = "ocaml-mycsv";
    
      src=./.;
    
      postUnpack="rm -f mycsv/Makefile.local mycsv/result"; # in case this is lying around

      buildInputs = [ ocaml findlib p1 ];
    
      createFindlibDestdir = true;

}
