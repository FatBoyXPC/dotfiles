{
  description = "A very basic flake specially crafted by JFly for FatBoyXPC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shtuff.url = "github:FatBoyXPC/shtuff/flake";
  };

  outputs = { self, nixpkgs, shtuff }: {

    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./. {
      shtuff = shtuff.packages.x86_64-linux.default;
    };

  };
}
