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
          x = 0; 
          y = 0; 
        };

	dynamic_padding = false;
	decorations = "Transparent";

        dimensions = {
	  lines = 45;
	  columns = 200;
	};
    };
  };
 };

}
