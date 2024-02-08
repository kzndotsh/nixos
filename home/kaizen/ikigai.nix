{...}: {
  home.username = "kaizen";
  home.homeDirectory = "/home/kaizen";

  home.packages = [
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "kaizen";
    userEmail = "admin@kaizen.wtf";
    extraConfig.init.defaultBranch = "main";
  };

  programs.eza = {
    enable = true;
  };
}
