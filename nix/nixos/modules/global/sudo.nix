{
  security.sudo = {
    enable = true;

    extraConfig = ''
      Defaults env_reset,pwfeedback
    '';
  };
}
