final: prev: {
  dmenu = prev.symlinkJoin {
    name = "dmenu_run";
    paths = [ prev.dmenu ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
    for prog in dmenu dmenu_run; do
      wrapProgram $out/bin/$prog \
        --add-flags "-fn 'Ubuntu Mono Regular:size=8:bold:antialias=true'"
    done
    '';
  };

}
