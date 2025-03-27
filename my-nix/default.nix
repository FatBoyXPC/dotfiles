{ symlinkJoin, pkgs, shtuff, with-alacritty }:

let
  autoperipherals = pkgs.callPackage ./packages/autoperipherals {};
  chromiumAlt = symlinkJoin {
    name = "chromium";
    paths = [ pkgs.chromium ];
    buildInputs = [ pkgs.makeWrapper ];
    # Adding these as command line flags doesn't seem to work. Perhaps
    # because we don't have this patch?
    # https://github.com/archlinux/svntogit-packages/blob/2aa76e8dfdd647d1ca0fe1d8780459660407bad2/chromium/trunk/use-oauth2-client-switches-as-default.patch
    postBuild = ''
      wrapProgram $out/bin/chromium \
        --set GOOGLE_DEFAULT_CLIENT_ID 77185425430.apps.googleusercontent.com \
        --set GOOGLE_DEFAULT_CLIENT_SECRET OTJgUOQcT7lO7GsGZq2G4IlT
    '';
  };
  flameshotAlt = pkgs.callPackage ./packages/flameshot {};
  mycliAlt = pkgs.mycli.overridePythonAttrs {
    #patches = [
      #(pkgs.fetchpatch {
        #url = "https://github.com/dbcli/mycli/compare/main...FatBoyXPC:mycli:add-collapsed-output-to-special-commands.patch";
        #hash = "sha256-vvTuGlYeFanSj3H1vn1KMMqzc6GajcSwlbbPO1DZIzk=";
      #})
    #];
    src = /home/james/dev/mycli;
  };
  slackAlt = symlinkJoin {
    name = "slack";
    paths = [ pkgs.slack ];
    buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/slack \
          --set BROWSER chromium
      '';
    };
  withAlacrittyAlt = wrap-nixgl with-alacritty;
  wrap-nixgl = pkgs.callPackage ./wrap-nixgl.nix {};
in

symlinkJoin {
  name = "my-nix";
  paths = with pkgs; [
    autoperipherals
    chromiumAlt
    direnv
    flameshotAlt
    mycli
    polybarFull
    shtuff
    slackAlt
    steam
    tldr
    uhk-agent
    withAlacrittyAlt
    xcwd
  ];
}
