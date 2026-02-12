{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
		agenix.url = "github:ryantm/agenix";
		agenix.inputs.nixpkgs.follows = "nixpkgs";
		agenix.inputs.darwin.follows = "";
    kbar.url = "github:maxdulay/kbar";
    kbar.inputs.nixpkgs.follows = "nixpkgs";
    omen-rust.url = "github:maxdulay/omen-fan-controller-rust";
    omen-rust.inputs.nixpkgs.follows = "nixpkgs";
    iamb.url = "github:ulyssa/iamb";
    iamb.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.nixtop= nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
					./nixtop/nixtop.nix
					inputs.agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.maxdu = import ./home.nix;
          }
        ];
      };
    };
}
