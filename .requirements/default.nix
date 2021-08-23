{ pkgs ? import <nixpkgs> {}, ... }:

let
    helloWorld = pkgs.writeScriptBin "helloWorld" ''
      #!{pkgs.stdenv.shell}
      echo Hello World
    '';

    nixPackages = with pkgs; [
        bashInteractive
        bash-completion
        coreutils-full
        dash
        i3lock
        zsh
    ];

in
pkgs.stdenv.mkDerivation {
    name = "default";
    buildInputs = nixPackages;
    src = /tmp/nix;
    system = builtins.currentSystem;
    outputs = [
        "out"
    ];
}
