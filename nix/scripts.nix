{
  lib,
  pkgs,
  ankiCustom,
  ...
}:
{
  watch = pkgs.writeShellScriptBin "watch" ''
    $SASS_COMMAND --watch "$@"
  '';

  build = pkgs.writeShellScriptBin "build" ''
    $SASS_COMMAND "$@"
  '';

  package = pkgs.writeShellScriptBin "package" ''
    pushd $ROOT_PATH > /dev/null
      python tools/build.py
    popd > /dev/null
  '';

  test = pkgs.writeShellScriptBin "test" ''
    ${lib.getExe ankiCustom} -b "$ROOT_PATH"/anki
  '';
}
