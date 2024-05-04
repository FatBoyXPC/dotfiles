{ symlinkJoin, pkgs, shtuff }:

symlinkJoin {
  name = "my-nix";
  paths = with pkgs; [
    mycli
    shtuff
    tldr
    (pkgs.callPackage ./flameshot {})
  ];
}
