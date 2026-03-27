{
  description = "doyougnu's blog generator via Emacs Overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Add the community Emacs overlay
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, emacs-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import nixpkgs with the emacs-overlay enabled
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import emacs-overlay) ];
        };

        # Use 'emacs-unstable-nox' or 'emacs-29-nox' from the overlay.
        # These are highly likely to have binary substitutes.
        myEmacs = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: with epkgs; [
          # org
          # ox-rss
          htmlize
          zig-mode
          haskell-mode
        ]);

      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "doyougnu-blog";
          src = ./.;

          buildInputs = [ myEmacs ];

          # Redirect HOME to avoid permission errors with Org timestamps
          buildPhase = ''
            export HOME=$TMPDIR
            emacs -q --script publish.el -f doyougnu/publish
          '';

          installPhase = ''
            mkdir -p $out
            # Assumes your publish.el outputs to a directory named 'build'
            cp -rv build/* $out/
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ myEmacs ];
        };
      });
}