{ lib }:
let
  merge = attrsList: lib.foldl' lib.recursiveUpdate { } attrsList;

  mkBlock = kind: name: value: {
    ${kind}.${name} = value;
  };
in
{
  inherit merge;

  mkVariable = name: attrs: mkBlock "variable" name attrs;

  mkOutput = name: attrs: mkBlock "output" name attrs;

  mkProvider = name: attrs: mkBlock "provider" name attrs;

  mkResource = type: name: attrs: {
    resource.${type}.${name} = attrs;
  };

  mkData = type: name: attrs: {
    data.${type}.${name} = attrs;
  };

  mkLocals = attrs: { locals = attrs; };

  mkTerraform = attrs: { terraform = attrs; };

  mkRequiredProviders = providers: mkTerraform {
    required_providers = providers;
  };

  mkBackend = backend: attrs: mkTerraform {
    backend.${backend} = attrs;
  };

  mkConfig = blocks: merge blocks;
}

