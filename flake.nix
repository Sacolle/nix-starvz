{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		starpu.url = "github:Sacolle/nix-starpu";
	};

	outputs = { self, nixpkgs, starpu }: 
	let
		system = "x86_64-linux";
        # –enable-maxcpus=count 
        # –enable-maxnumanodes=count 
        # –enable-maxcudadev=count 
		StarPU = (starpu.packages.${system}.default.override {
			enableCUDA = false;
			enableTrace = true;
            extraOptions = [ "--enable-maxcpus=256" ];
		});
		pkgs = import nixpkgs { inherit system; };
		starvz = pkgs.callPackage ./starvz.nix { inherit StarPU; };
        poti = pkgs.callPackage ./poti.nix {};
        pajeng = pkgs.callPackage ./pajeng.nix {};
	in
	{
		packages.${system} = {
			default = starvz;
            inherit starvz poti pajeng;
		};

        devShells.${system}.default = pkgs.mkShell {
            buildInputs = [
                pkgs.recutils
                pkgs.pkg-config
                pkgs.zlib

                StarPU
                poti
                pajeng
                (pkgs.rWrapper.override {
                    packages = [ starvz ];
                })
            ];
        };
	};
}
