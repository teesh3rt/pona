
{
    description = "toki";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        gleam.url = "github:gleamnix/gleamnix";
    };

    outputs = { self, nixpkgs, gleam }:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        devShells.${system}.default = pkgs.mkShell {
            packages = [
                gleam.packages.${system}.default
                pkgs.coreutils
            ];
        };
    };
}
                