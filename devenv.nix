{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    dart-sass
    prettierd
  ];

  cachix.enable = false;

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
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

  # https://devenv.sh/processes/
  processes.sass-watch.exec = "sass --no-source-map src/styles/scss:src/styles/css --watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.sb.exec = "sass --no-source-map src/styles/scss:src/styles/css";
  scripts.sw.exec = "sass --no-source-map src/styles/scss:src/styles/css --watch";
  scripts.sp.exec = "python tools/build.py";

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    prettier = {
      enable = true;
      fail_fast = true; # stop running hooks if prettier fails
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
