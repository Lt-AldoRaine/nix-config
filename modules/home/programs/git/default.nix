{ lib, ... }: {
  programs.git = lib.mkMerge [
    { enable = lib.mkDefault true; }
    {
      settings = {
        user.name = "Connor Pennington";
        user.email = "harambefallon@gmail.com";
      };
    }
  ];
}
