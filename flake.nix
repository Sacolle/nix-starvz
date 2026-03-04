{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		starvz-src = {
			type = "github";
			owner = "schnorr";
			repo = "starvz";
			# add a specific commit?
			flake = false;
		};
	};

	outputs = { self, nixpkgs, starvz-src }: 
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; };
		starvz = pkgs.stdenv.mkDerivation {
			pname = "starvz";
			version = "0.7.1";

			src = starvz-src;

			installPhase = ''
				mkdir -p $out
				cp -r $src $out
			'';
		};
	in
	{
		packages.${system} = {
			starvz = starvz;
			default = starvz;
			poti = pkgs.callPackage ./poti.nix {};
		};
	};
}
