{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
		starpu.url = "github:Sacolle/nix-starpu";
	};

	outputs = { self, nixpkgs, flake-utils, starpu }:
	flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
	let
		StarPU = (starpu.packages.${system}.default.override {
			enableCUDA = false;
			enableTrace = true;
            extraOptions = [ "--enable-maxcpus=256" ];
		});
		pkgs = import nixpkgs { inherit system; };
		starvz = pkgs.callPackage ./starvz.nix {};
        poti = pkgs.callPackage ./poti.nix {};
        pajeng = pkgs.callPackage ./pajeng.nix {};
		starvzTools = pkgs.callPackage ./starvzTools.nix { 
            inherit StarPU starvz poti pajeng; 
        };
	in
	{
		packages = {
			default = starvzTools;
            inherit starvz starvzTools poti pajeng;
		};
	});
}
