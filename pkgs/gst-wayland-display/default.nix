{
rustPlatform,
fetchFromGitHub,
pkg-config,
cargo-c,
mesa,
libglvnd,
pipewire,
glib,
wayland,
libinput,
libxkbcommon,
gst_all_1,
udev,
rust,
stdenv
}:
rustPlatform.buildRustPackage rec {
  pname = "gst-wayland-display";
  version = "git.6c7d8cb";

  src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "gst-wayland-display";
    rev = "6c7d8cbd53b3d606d9bc7ea9d9922656f84609ad";
    hash = "sha256-U08f5A/Mui9C33uNh9OB16zjaQHhZyUkA7nOYLZf2oQ=";
  };
  nativeBuildInputs = [ pkg-config cargo-c ];
  buildInputs = [
    mesa
    libglvnd
    pipewire
    glib
    wayland
    libinput
    libxkbcommon
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi

    udev
  ];

  cargoLockFile =
    builtins.toFile "cargo.lock" (builtins.readFile "${src}/Cargo.lock");
  cargoLock = {
    lockFile = cargoLockFile;
    outputHashes = {
      "smithay-0.3.0" = "sha256-WKWdSAEnnim3CPRMUrl+9iCew5narNupObgNiyYKsq4=";
    };
  };

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  postPatch = ''
    cp ${cargoLockFile} Cargo.lock
  '';
  buildPhase = ''
              export HOME=$(mktemp -d)
    runHook preBuild
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${
      placeholder "out"
    } --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';
  # installPhase = "${pkgs.rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${pkgs.stdenv.hostPlatform.rust.rustcTarget}";
  installPhase = ''
    runHook preInstall
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${
      placeholder "out"
    } --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';
}
