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
        default = pkgs.mkShell {
          inputsFrom = [
            self'.devShells."basic"
            self'.devShells."aliases-basic"
            self'.devShells.aliases
            config.pre-commit.devShell
            config.treefmt.build.devShell
          ];
        };
      };
    };
}
