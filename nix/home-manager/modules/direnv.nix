{
  # https://github.com/direnv/direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    # https://github.com/nix-community/nix-direnv
    nix-direnv.enable = true;
  };
}
