{
  self ? import ./nix/import-flake.nix { src = ./.; },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
lib.makeScope pkgs.newScope (scope: {
  inherit
    lib
    pkgs
    self
    system
    inputs
    ;

  formatter = scope.callPackage ./nix/formatter.nix { };
  scripts = scope.callPackage ./nix/scripts.nix { };

  ankiCustom = pkgs.anki.withAddons (
    with pkgs.ankiAddons;
    [
      anki-connect
    ]
  );

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

  devShells.default = pkgs.mkShellNoCC {
    packages =
      (with pkgs; [
        dart-sass
        gitMinimal
        prettierd
      ])
      ++ (with scope; [
        devPython
        formatter.package
        scripts.build
        scripts.package
        scripts.test
        scripts.watch
      ]);

    shellHook = ''
      export ROOT_PATH=$(git rev-parse --show-toplevel)
      export SASS_COMMAND="sass $ROOT_PATH/src/styles/scss:$ROOT_PATH/src/styles/css"
    '';
  };

  flake.packages = lib.filterAttrs (n: v: lib.isDerivation v) scope.scripts;
  flake.devShells = scope.devShells;
  flake.formatter = scope.formatter.package;
})
