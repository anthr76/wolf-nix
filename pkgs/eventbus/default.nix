{ stdenv, cmake, pkg-config, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "eventbus";
  version = "0.10.2";
  src = fetchFromGitHub {
    owner = "DeveloperPaul123";
    repo = "eventbus";
    rev = "refs/tags/0.10.2";
    sha256 = "sha256-OPrDFC6HwReWcqB13AUwjrJNursiaglisffUR8/QARU=";
  };
  patches = [
    ./0001-cmake-install.patch
  ];
  nativeBuildInputs = [ cmake pkg-config ];
  configurePhase = [ "rm -rf demo" ];
  cmakeFlags = [ 
  "-DEVENTBUS_BUILD_TESTS=OFF" 
  ];

}
