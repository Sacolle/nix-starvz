{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		starpu.url = "github:Sacolle/nix-starpu";
	};

	outputs = { self, nixpkgs, starpu }: 
	let
		system = "x86_64-linux";
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
		packages.${system} = {
			default = starvzTools;
            inherit starvz starvzTools poti pajeng;
		};
	};
}
