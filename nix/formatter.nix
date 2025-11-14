{
  lib,
  pkgs,
  inputs,
  ...
}:
lib.makeExtensible (self: {
  treefmt = import inputs.treefmt-nix;

  config = {
    projectRootFile = "default.nix";

    programs.actionlint.enable = true;
    programs.zizmor.enable = true;

    programs.nixfmt.enable = true;
    programs.prettier.enable = true;
    programs.ruff-format.enable = true;
    programs.yamlfmt.enable = true;
  };

  module = with self; treefmt.evalModule pkgs config;

  package = with self; treefmt.mkWrapper pkgs config;
  packages = with self; (treefmt.evalModule pkgs config).config.build.devShell.nativeBuildInputs;
})
