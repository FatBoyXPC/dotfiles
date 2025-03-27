{
  description = "A very basic flake specially crafted by JFly for FatBoyXPC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shtuff.url = "github:jfly/shtuff";
    with-alacritty.url = "github:FatBoyXPC/with-alacritty";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, shtuff, with-alacritty, nixgl }:
  let
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "slack"
          "steam"
          "steam-unwrapped"
          "uhk-agent"
        ];
      overlays = [ nixgl.overlay ];
    };
    in
    {

      packages.x86_64-linux.default = pkgs.callPackage ./. {
        shtuff = shtuff.packages.x86_64-linux.default;
        with-alacritty = with-alacritty.packages.x86_64-linux.default;
      };

    };

}
