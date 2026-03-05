{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		starpu =  {
			type = "github";
			owner = "Sacolle";
			# will change
			repo = "nix-starpu-dev";
		};
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
            # não parece ser necessário
            # buildMode = "release";
		}).overrideAttrs (oldAttrs: {
        configureFlags = (oldAttrs.configureFlags or []) ++ [
                "--with-maxcpus=256"      # Aumenta o limite de núcleos de CPU
                # "--with-maxcuda=16"       # Mesmo com enableCUDA=false, defina para o tool aceitar traces com CUDA
                # "--with-maxnodes=4"       # Importante para máquinas NUMA grandes
            ];
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
