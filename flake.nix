{
    description = "Cool nix flake";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-25.11";
        home-manager.url = "github:nix-community/home-manager/release-25.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        niri.url = "github:sodiboo/niri-flake";
        niri.inputs.nixpkgs.follows = "nixpkgs";
    };
  
    outputs = inputs@{ nixpkgs, home-manager, niri, ... }: {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix
                niri.nixosModules.niri
                home-manager.nixosModules.home-manager
                {
                    nixpkgs.overlays = [
                      (final: prev: {
                        niri = prev.niri.overrideAttrs (old: {
                          doCheck = false;
                        });
                      })
                    ];
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.finn = import ./home.nix;
                    home-manager.backupFileExtension = "backup";
                    home-manager.extraSpecialArgs = { inherit niri; };
                }
            ];
        };
    };
  
}
