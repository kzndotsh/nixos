{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
  };

  programs.zsh.antidote = {
    enable = true;
    plugins = [
      # ZSH utility plugins
      "zsh-users/zsh-autosuggestions"
      "zsh-users/zsh-syntax-highlighting"
      "zsh-users/zsh-completions"
      "zsh-users/zsh-history-substring-search"
      # ZSH prompt
      "sindresorhus/pure"
      # Extra
      "z-shell/zsh-eza"
    ];
  };
}
