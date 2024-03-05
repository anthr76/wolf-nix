{ pkgs ? import <nixpkgs> { } }: rec {
  gst-wayland-display = pkgs.callPackage ./gst-wayland-display { };
  wolf = pkgs.callPackage ./wolf { gst-wayland-display = gst-wayland-display; };
  eventbus = pkgs.callPackage ./eventbus { };
}
