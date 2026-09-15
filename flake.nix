{
  description = "Node toolchain for building the frontend and regenerating yarn.lock";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        # Node only. The Rust backend is not built here; add pkgs.rustup or a
        # toolchain input if you ever need `cargo` alongside this.
        default = pkgs.mkShell {
          name = "ryot-node";

          # `yarn-berry` only bootstraps yarn: .yarnrc.yml pins `yarnPath` to
          # .yarn/releases/yarn-4.1.1.cjs, so the vendored 4.1.1 always runs.
          packages = [
            pkgs.nodejs_24
            pkgs.yarn-berry
          ];

          shellHook = ''
            echo "node $(node --version), yarn $(yarn --version)"
          '';
        };
      });
    };
}
