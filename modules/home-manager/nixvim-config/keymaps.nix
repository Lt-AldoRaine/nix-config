{ config, lib, ... }: {
  programs.nixvim = {
	globals = {
      mapleader = " ";
      mapLocalleader = " ";
	};

	keymaps = 
	  let
		normal = 
		  lib.mapAttrsToList 
	        (key: action: { 
	        mode = "n"; 
		    inherit action key;
		    })
			{

		    }
  };
}
