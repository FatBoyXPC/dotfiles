{ pkgs, ... }:

wrap-me: (
  pkgs.symlinkJoin {
    name = wrap-me.name;
    paths = [ wrap-me ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for full_path in $out/bin/*; do
        f=$(basename $full_path)
        rm $out/bin/$f
        echo "#!${pkgs.runtimeShell}" > $out/bin/$f
        echo "exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${wrap-me}/bin/$f" '"$@"' >> $out/bin/$f
        chmod +x $out/bin/$f
      done
    '';
  }
)
