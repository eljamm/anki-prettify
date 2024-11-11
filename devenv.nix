{ self, pkgs, ... }:
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git

    dart-sass
    prettierd
  ];

  cachix.enable = false;

  # https://devenv.sh/languages/
  languages.python = {
    enable = true;
    venv.enable = true;
    venv.requirements = ''
      cached-property==1.5.2
      certifi==2022.12.7
      charset-normalizer==3.0.1
      chevron==0.14.0
      frozendict==2.3.4
      genanki==0.13.1
      idna==3.4
      requests==2.28.2
      urllib3==1.26.14
    '';
    libraries = [ pkgs.python3Packages.pyyaml ];
  };

  enterShell = ''
    export GIT_DIR=$(git rev-parse --show-toplevel)
    export SASS_COMMAND="sass $GIT_DIR/src/styles/scss:$GIT_DIR/src/styles/css"
  '';

  # https://devenv.sh/processes/
  processes.sass-watch.exec = "$SASS_COMMAND --watch";

  # https://devenv.sh/scripts/
  scripts.ss.exec = "$SASS_COMMAND"; # Compile css files
  scripts.sw.exec = "$SASS_COMMAND --watch"; # Watch scss folder & compile files
  scripts.sp.exec = # Package Anki decks
    ''
      pushd $GIT_DIR > /dev/null
        python tools/build.py
      popd > /dev/null
    '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    prettier = {
      enable = true;
      fail_fast = true; # stop running hooks if prettier fails
    };
  };
}
