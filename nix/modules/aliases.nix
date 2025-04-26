{
  perSystem =
    { pkgs, devLib, ... }:
    {
      devShells = {
        aliases = pkgs.mkShellNoCC {
          packages = devLib.mkAliases {
            # Nix
            nbb = "nix build --show-trace --print-build-logs";
            nrr = "nix run --show-trace --print-build-logs";
          };
        };
      };
    };
}
