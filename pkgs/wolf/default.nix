{
stdenv,
fetchFromGitHub,
cmake,
pkg-config,
ninja,
wrapGAppsHook,
gst-wayland-display,
wayland,
icu,
git,
pciutils,
range-v3,
elfutils,
libinput,
libxkbcommon,
pcre2,
libunwind,
orc,
libdrm,
boost175,
gst_all_1,
libevdev,
libpulseaudio,
openssl,
curl,
immer
}:
stdenv.mkDerivation {
  pname = "wolf";
  version = "git.b9b9de3";
  src = fetchFromGitHub {
    owner = "games-on-whales";
    repo = "wolf";
    rev = "b9b9de38d752f954aea93a51386c8d934fc16cec";
    sha256 = "sha256-GOhys7gSe3dZKzk/6Ui5q6uA1PuvdGVQse51BPxyOfs=";
    fetchSubmodules = true;
  };
  patches = [ ];

  nativeBuildInputs = [ cmake pkg-config ninja wrapGAppsHook];

  buildInputs = [
    gst-wayland-display
    wayland
    icu
    pciutils
    git
    range-v3
    elfutils
    libinput
    libxkbcommon
    pcre2
    libunwind
    orc
    libdrm
    boost175
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi
    libevdev
    libpulseaudio
    openssl
    curl
    immer
  ];
  # ++ lib.optionals cudaSupport [
  # cudaPackages.cudatoolkit
  # ] ++ lib.optionals stdenv.isx86_64 [
  # intel-media-sdk
  # ];

  cmakeFlags = [
    # "-DFETCHCONTENT_SOURCE_DIR_EVENTBUS=${deps.eventbus_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_BOOST_JSON=${deps.boost-json_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_RANGE=${deps.range_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_FMTLIB=${deps.fmtlib_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_NANORS=${deps.nanors_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_PEGLIB=${deps.peglib_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_SIMPLEWEBSERVER=${deps.simplewebserver_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_TOML=${deps.toml_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_ENET=${deps.enet_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_CPPTRACE=${deps.cpptrace_src}"
    # "-DFETCHCONTENT_SOURCE_DIR_LIBDWARF=${deps.libdwarf_src}"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_STANDARD=17"
    "-DCMAKE_CXX_EXTENSIONS=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DBUILD_FAKE_UDEV_CLI=ON"
    "-DBUILD_TESTING=OFF"
    "-G Ninja"
  ];
  buildPhase = ''
    # mkdir -p $out/bin
    ninja wolf
    # ninja fake-udev
    # cp -r $src/src $out/bin
    # cp ./src/moonlight-server/wolf $out/bin/wolf
  '';
  installPhase = ''
    mkdir -p $out/bin
    # cp -r $src/src $out/bin
    cp ./src/moonlight-server/wolf $out/bin/wolf
    # cp ./src/fake-udev/fake-udev $out/bin/fake-udev
  '';
}
