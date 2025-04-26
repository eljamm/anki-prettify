{
  lib,
  callPackage,
  writeShellApplication,
  ...
}:
rec {
  attrsToApp =
    attrs:
    (writeShellApplication {
      name = attrs.name;
      text = if (lib.isAttrs attrs.value) then attrs.value.text else attrs.value + " \"$@\"";
      runtimeInputs = if (lib.isAttrs attrs.value) then attrs.value.runtimeInputs or [ ] else [ ];
    });
  mkAliases = aliases: map attrsToApp (lib.attrsToList aliases);
}
