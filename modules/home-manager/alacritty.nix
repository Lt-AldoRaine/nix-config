{ pkgs, ... }: 

{
 home.packages = with pkgs; [
  alacritty
 ];

 programs.alacritty = {
  enable = true;

  settings = {
      window = {
      padding = {
        x = 8; 
      };
    };
  };
 };

}
