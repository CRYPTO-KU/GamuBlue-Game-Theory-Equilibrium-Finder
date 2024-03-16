# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using `nix build .#example` or (legacy) `nix-build -A example`
{pkgs ? (import ../nixpkgs.nix) {}}: {
  # example = pkgs.callPackage ./example { };
  gambit = pkgs.callPackage ./gambit {};
  pygambit = pkgs.callPackage ./gambit/pygambit.nix {
    inherit (pkgs.python3.pkgs) buildPythonPackage pytest cython lxml numpy scipy;
  };
}
