{ symlinkJoin, pkgs, shtuff, with-alacritty }:

let wrap-nixgl = pkgs.callPackage ./wrap-nixgl.nix {}; in

symlinkJoin {
  name = "my-nix";
  paths = with pkgs; [
    mycli
    shtuff
    tldr
    (pkgs.callPackage ./flameshot {})
    (wrap-nixgl with-alacritty )
  ];
}
