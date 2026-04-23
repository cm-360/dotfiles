{
  writeShellApplication,
  prelink,
}:
writeShellApplication {
  name = "patch-galaxy-api";

  runtimeInputs = [ prelink ];

  # https://forums.stardewvalley.net/threads/galaxy-api-not-loading-with-glibc-2-41.36974/
  text = ''
    execstack -c libGalaxy64.so
    execstack -c libGalaxyCSharpGlue.so

    "$@"
  '';
}
