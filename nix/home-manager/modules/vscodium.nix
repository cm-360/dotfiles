{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    # https://github.com/nix-community/nix-vscode-extensions
    extensions =
      # https://marketplace.visualstudio.com/vscode
      (with pkgs.vscode-marketplace; [
        ms-python.python
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        mtxr.sqltools
        myriad-dreamin.tinymist
        pkief.material-icon-theme
        pkief.material-product-icons
        svelte.svelte-vscode
        tamasfe.even-better-toml
        tomoki1207.pdf
      ])
      # https://open-vsx.org/
      ++ (with pkgs.open-vsx; [
        akamud.vscode-theme-onedark
        charliermarsh.ruff
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        golang.go
        jebbs.plantuml
        jkillian.custom-local-formatters
        jnoortheen.nix-ide
        maelvalais.autoconf
        mechatroner.rainbow-csv
        ms-python.debugpy
        ms-toolsai.jupyter
      ]);
  };
}
