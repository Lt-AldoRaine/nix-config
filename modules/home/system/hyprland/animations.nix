{ config, lib }:
let
  animationSpeed = config.var.theme.animation-speed;

  animationDuration = if animationSpeed == "slow" then
    "4"
  else if animationSpeed == "medium" then
    "2.5"
  else
    "1.5";
  borderDuration = if animationSpeed == "slow" then
    "10"
  else if animationSpeed == "medium" then
    "6"
  else
    "3";

  beziers = [
    "linear, 0, 0, 1, 1"
    "md3_standard, 0.2, 0, 0, 1"
    "md3_decel, 0.05, 0.7, 0.1, 1"
    "md3_accel, 0.3, 0, 0.8, 0.15"
    "overshot, 0.05, 0.9, 0.1, 1.1"
    "crazyshot, 0.1, 1.5, 0.76, 0.92"
    "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
    "menu_decel, 0.1, 1, 0, 1"
    "menu_accel, 0.38, 0.04, 1, 0.07"
    "easeInOutCirc, 0.85, 0, 0.15, 1"
    "easeOutCirc, 0, 0.55, 0.45, 1"
    "easeOutExpo, 0.16, 1, 0.3, 1"
    "softAcDecel, 0.26, 0.26, 0.15, 1"
    "md2, 0.4, 0, 0.2, 1"
  ];

  animationSpecs = [
    "windows, 1, ${animationDuration}, md3_decel, popin 60%"
    "windowsIn, 1, ${animationDuration}, md3_decel, popin 60%"
    "windowsOut, 1, ${animationDuration}, md3_accel, popin 60%"
    "border, 1, ${borderDuration}, default"
    "fade, 1, ${animationDuration}, md3_decel"
    "layersIn, 1, ${animationDuration}, menu_decel, slide"
    "layersOut, 1, ${animationDuration}, menu_accel"
    "fadeLayersIn, 1, ${animationDuration}, menu_decel"
    "fadeLayersOut, 1, ${animationDuration}, menu_accel"
    "workspaces, 1, ${animationDuration}, menu_decel, slide"
    "specialWorkspace, 1, ${animationDuration}, md3_decel, slidevert"
  ];

  splitFields = s: map lib.trim (lib.splitString "," s);

  mkCurve = s:
    let
      fields = splitFields s;
      pts = builtins.tail fields;
    in {
      _args = [
        (builtins.elemAt fields 0)
        {
          type = "bezier";
          points = [
            [ (builtins.fromJSON (builtins.elemAt pts 0)) (builtins.fromJSON (builtins.elemAt pts 1)) ]
            [ (builtins.fromJSON (builtins.elemAt pts 2)) (builtins.fromJSON (builtins.elemAt pts 3)) ]
          ];
        }
      ];
    };

  mkAnimation = s:
    let
      fields = splitFields s;
      leaf = builtins.elemAt fields 0;
      enabled = (builtins.elemAt fields 1) == "1";
      speed = builtins.fromJSON (builtins.elemAt fields 2);
      curve = builtins.elemAt fields 3;
      hasStyle = builtins.length fields > 4;
    in {
      inherit leaf enabled speed;
      bezier = curve;
    } // lib.optionalAttrs hasStyle { style = builtins.elemAt fields 4; };
in {
  curves = map mkCurve beziers;
  animations = map mkAnimation animationSpecs;
}
