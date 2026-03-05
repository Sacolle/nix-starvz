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
		StarPU = starpu.packages.${system}.default.override {
			enableCUDA = false;
			enableTrace = true;
		};
		pkgs = import nixpkgs { inherit system; };
		starvz = pkgs.callPackage ./starvz.nix { inherit StarPU; };
	in
	{
		packages.${system} = {
			starvz = starvz;
			default = starvz;
			poti = pkgs.callPackage ./poti.nix {};
			pajeng = pkgs.callPackage ./pajeng.nix {};

			devShells.default = pkgs.mkShell {
				buildInputs = [
					(pkgs.rWrapper.override {
						packages = [ starvz ];
					})
				];
			};
		};
	};
}
