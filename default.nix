let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
  inherit (flake-inputs)
    import-flake
    ;
in
{
  self ? import-flake {
    src = ./.;
  },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;
    inherit (default)
      packages
      ;
    devShells = default.shells;
  };

  formatter = import ./nix/formatter.nix args;
  scripts = import ./nix/scripts.nix args;

  default = rec {
    packages = { };

    shells = {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          dart-sass
          devPython
          formatter.package
          gitMinimal
          prettierd
          scripts.build
          scripts.package
          scripts.test
          scripts.watch
        ];

        shellHook = ''
          export ROOT_PATH=$(git rev-parse --show-toplevel)
          export SASS_COMMAND="sass $ROOT_PATH/src/styles/scss:$ROOT_PATH/src/styles/css"
        '';
      };
    };

    devPython = pkgs.python3.withPackages (
      ps: with ps; [
        cached-property
        certifi
        charset-normalizer
        chevron
        frozendict
        genanki
        idna
        requests
        urllib3
      ]
    );

    flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    flake.devShells = shells;
    flake.formatter = formatter.package;
  };
in
default // args
