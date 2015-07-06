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
    
      buildInputs = [ ocaml findlib p1 ];
    
#      postInstall="cp -R build src $out";
           
      createFindlibDestdir = true;
}
