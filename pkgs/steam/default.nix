{
dockerTools,
buildEnv,
steam
}:
dockerTools.buildImage {
  name = "steam";
  copyToRoot = buildEnv {
    name = "image-root";
    paths = [ 
      steam
    ];
    pathsToLink = [ "/bin" ];
  };

  # config.Cmd = [ "/bin/hello" ];
}
