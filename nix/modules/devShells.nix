{
  perSystem =
    {
      config,
      self',
      pkgs,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          inputsFrom = [
            self'.devShells.aliases
            config.pre-commit.devShell
            config.treefmt.build.devShell
          ];

          packages = with pkgs; [
            dart-sass
            prettierd
            (python3.withPackages (
              ps: with ps; [
                genanki
                requests
              ]
            ))
          ];
        };
      };
    };
}
