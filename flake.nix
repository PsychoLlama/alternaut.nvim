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
      packages = eachSystem (
        system: pkgs: rec {
          default = alternaut-nvim;

          alternaut-nvim = pkgs.vimUtils.buildVimPlugin {
            pname = "alternaut.nvim";
            version = self.shortRev or "latest";
            src = ./.;
          };
        }
      );

      devShells = eachSystem (
        system: pkgs:

        let
          standardPackages = [
            pkgs.just
            pkgs.lua-language-server
            pkgs.luajitPackages.luacheck
            pkgs.luajitPackages.vusted
            pkgs.nixfmt-rfc-style
            pkgs.stylua
            pkgs.treefmt
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
