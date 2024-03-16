# Development environment
# You can enter it through `nix develop` or (legacy) `nix-shell`
{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      hyperfine # Benchmarking tool

      gambit

      (python3.withPackages (ps:
        with ps; [
          pygambit # custom package
          more-itertools
          numpy
        ]))
      (ruby.withPackages (ps: with ps; [optimist]))
    ];
  };
}
