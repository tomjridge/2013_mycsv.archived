{ }:
let 
  pkgs = import <nixpkgs> {};
  op = pkgs.ocamlPackages;
  inherit (pkgs) stdenv fetchgit ocaml;
  inherit (pkgs.ocamlPackages) findlib opam;

in
let 
  p1 = stdenv.mkDerivation {
      name = "p1";
    
    src = fetchgit {
      url = https://github.com/tomjridge/p1.git;
      rev = "543eb4";
      sha256 = "57dd7f20fa2b487f6ae7d2ad9f6c35efeacc238afc54275c01a130e3b3c0573e";
    };
    
      buildInputs = [ ocaml findlib ];
    
      createFindlibDestdir = true;

      postInstall=''
        cp -R build gen $out
        mkdir -p $out/bin && cp build/*.native $out/bin
      '';
    };
in
stdenv.mkDerivation {

      name = "ocaml-mycsv";
    
      src = fetchgit {
        url = https://github.com/tomjridge/mycsv.git;
        rev = "8fd68e";
        sha256 = "e326422903a6153569b7efa49941cfc8733208495dc51f49c9e92e45603043e8";
      };
    
      postUnpack="rm -f mycsv/Makefile.local mycsv/result"; # in case this is lying around

      buildInputs = [ ocaml findlib p1 ];
    
      createFindlibDestdir = true;

}
