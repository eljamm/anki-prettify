{
  lib,
  pkgs,
  inputs,
  system,
  ...
}@args:
let
  git-hooks = import inputs.git-hooks { inherit system; };
  treefmt-nix = import inputs.treefmt-nix;

  treefmt = treefmt-nix.mkWrapper pkgs {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.prettier.enable = true;
    programs.ruff-format.enable = true;
  };

  pre-commit-hook = pkgs.writeShellScriptBin "git-hooks" ''
    if [[ -d .git ]]; then
      ${with git-hooks.lib.git-hooks; pre-commit (wrap.abort-on-change treefmt)}
    fi
  '';

  format = pkgs.writeShellScriptBin "format" ''
    ${lib.getExe treefmt}
  '';
in
{
  inherit
    pre-commit-hook
    format
    ;
}
