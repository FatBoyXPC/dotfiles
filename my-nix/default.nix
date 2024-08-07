{ symlinkJoin, pkgs, shtuff, with-alacritty }:

let
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
  flameshotAlt = pkgs.callPackage ./flameshot {};
  withAlacrittyAlt = wrap-nixgl with-alacritty;
  wrap-nixgl = pkgs.callPackage ./wrap-nixgl.nix {};
in

symlinkJoin {
  name = "my-nix";
  paths = with pkgs; [
    chromiumAlt
    direnv
    flameshotAlt
    mycli
    shtuff
    tldr
    withAlacrittyAlt
    xcwd
  ];
}
