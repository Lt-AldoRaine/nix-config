{ lib }:
let
  inherit (lib.generators) mkLuaInline;

  luaStrLit = s:
    ''"${lib.replaceStrings [ "\\" "\"" ] [ "\\\\" "\\\"" ] s}"'';
in rec {
  inherit luaStrLit;

  luaFn = lines:
    mkLuaInline
    ("function()\n" + lib.concatMapStrings (l: "  ${l}\n") lines + "end");

  dsp = {
    exec = cmd: mkLuaInline "hl.dsp.exec_cmd(${luaStrLit cmd})";

    focus = dir: mkLuaInline ''hl.dsp.focus({ direction = ${luaStrLit dir} })'';
    focusWorkspace = ws:
      mkLuaInline "hl.dsp.focus({ workspace = ${toString ws} })";

    windowClose = mkLuaInline "hl.dsp.window.close()";

    windowFullscreen = mode:
      if mode == null then
        mkLuaInline "hl.dsp.window.fullscreen()"
      else
        mkLuaInline ''hl.dsp.window.fullscreen({ mode = ${luaStrLit mode} })'';

    windowMoveDirection = dir:
      mkLuaInline ''hl.dsp.window.move({ direction = ${luaStrLit dir} })'';
    windowMoveWorkspace = ws:
      mkLuaInline "hl.dsp.window.move({ workspace = ${toString ws} })";

    windowResizeRelative = x: y:
      mkLuaInline
      "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";

    windowDrag = mkLuaInline "hl.dsp.window.drag()";
    windowResize = mkLuaInline "hl.dsp.window.resize()";
  };
}
