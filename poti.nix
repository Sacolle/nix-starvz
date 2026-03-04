{ 
    lib,
    fetchFromGitHub,
    stdenv,
    perl,
    cmake
}:
stdenv.mkDerivation (finalAttrs: {
    pname = "poti";
    system = "x86_64-linux";
    version = "5.0";

    src = fetchFromGitHub {
        owner = "schnorr";
        repo = "poti";
        rev = "poti-5.0";
        hash = "sha256-t0xmO1G3vUnqhJDm9UrZAt8nGo+6+9tQsBgDrsGgN3M=";
    };
    nativeBuildInputs = [
        perl
	cmake # adding cmake as a buildinput does everything else automatically
    ];
    buildInputs = [ ];
    # poti's cmake version is less then 3.5, so i need to tell it do it anyway.
    cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

    doCheck = true;
})
