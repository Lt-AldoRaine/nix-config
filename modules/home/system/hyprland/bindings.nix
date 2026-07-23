{ pkgs, lib }:
let
  hlLib = import ./lib.nix { inherit lib; };

  mod = "SUPER";

  mkBind = keys: dispatcher: { _args = [ keys dispatcher ]; };
  mkBindOpts = keys: dispatcher: opts: { _args = [ keys dispatcher opts ]; };

  execBinds = [
    {
      key = "E";
      cmd = "${pkgs.xfce.thunar}/bin/thunar";
    }
    {
      key = "D";
      cmd = "discord";
    }
    {
      key = "B";
      cmd = "firefox";
    }
    {
      key = "SPACE";
      cmd = "wofi";
    }
    {
      key = "RETURN";
      cmd = "kitty";
    }
  ];

  directions = [
    {
      key = "K";
      dir = "u";
    }
    {
      key = "J";
      dir = "d";
    }
    {
      key = "H";
      dir = "l";
    }
    {
      key = "L";
      dir = "r";
    }
  ];

  resizeBinds = [
    {
      key = "K";
      x = 0;
      y = -15;
    }
    {
      key = "J";
      x = 0;
      y = 15;
    }
    {
      key = "H";
      x = -15;
      y = 0;
    }
    {
      key = "L";
      x = 15;
      y = 0;
    }
  ];

  execEntries =
    map (b: mkBind "${mod} + ${b.key}" (hlLib.dsp.exec b.cmd)) execBinds;

  focusEntries =
    map (b: mkBind "${mod} + ${b.key}" (hlLib.dsp.focus b.dir)) directions;

  moveWindowEntries = map
    (b: mkBind "${mod} + SHIFT + ${b.key}" (hlLib.dsp.windowMoveDirection b.dir))
    directions;

  resizeEntries = map
    (b: mkBind "${mod} + ALT + ${b.key}" (hlLib.dsp.windowResizeRelative b.x b.y))
    resizeBinds;

  workspaceEntries = lib.flatten (map (i:
    let
      ws = i + 1;
      keys = "${mod} + code:1${toString i}";
      shiftKeys = "${mod} + SHIFT + code:1${toString i}";
    in [
      (mkBind keys (hlLib.dsp.focusWorkspace ws))
      (mkBind shiftKeys (hlLib.dsp.windowMoveWorkspace ws))
    ]) (lib.range 0 8));

  mouseEntries = [
    (mkBindOpts "${mod} + mouse:272" hlLib.dsp.windowDrag { mouse = true; })
    (mkBindOpts "${mod} + R" hlLib.dsp.windowResize { mouse = true; })
  ];
in execEntries ++ [
  (mkBind "${mod} + Q" hlLib.dsp.windowClose)
  (mkBind "${mod} + F" (hlLib.dsp.windowFullscreen "maximized"))
  (mkBind "${mod} + SHIFT + F" (hlLib.dsp.windowFullscreen null))
  (mkBind "${mod} + SHIFT + W" (hlLib.dsp.exec "wallpaper-cycle"))
] ++ focusEntries ++ moveWindowEntries ++ resizeEntries ++ workspaceEntries
++ mouseEntries
