{
  description = "Development environment";

  inputs.systems.url = "github:nix-systems/default";

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:

    let
      inherit (nixpkgs) lib;

      eachSystem = lib.flip lib.mapAttrs (
        lib.genAttrs (import systems) (system: nixpkgs.legacyPackages.${system})
      );
    in

    {
      devShells = eachSystem (
        system: pkgs:

        let
          standardPackages = [
            pkgs.luajitPackages.luacheck
            pkgs.luajitPackages.vusted
            pkgs.stylua
          ];
        in

        {
          # For developing locally. Uses the system neovim.
          default = pkgs.mkShell {
            packages = standardPackages;
          };

          # For CI. Uses an unconfigured neovim package.
          ci = pkgs.mkShell {
            packages = standardPackages ++ [
              pkgs.neovim
            ];
          };
        }
      );
    };
}
