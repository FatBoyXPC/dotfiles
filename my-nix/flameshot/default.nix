{ pkgs }:

pkgs.flameshot.overrideAttrs (oldAttrs: {
  patches = [
    ./0000-issue-1072-workaround.diff
  ];
})
