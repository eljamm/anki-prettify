{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt.projectRootFile = "flake.nix";
      treefmt.programs.nixfmt.enable = true;


      pre-commit.check.enable = true;
      pre-commit.settings.hooks.treefmt.enable = true;
      pre-commit.settings.hooks.treefmt.settings.no-cache = false;
    };
}
