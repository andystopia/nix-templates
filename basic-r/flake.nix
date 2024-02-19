{
  description = "A package for MacOS, which attempts to install R packages for reproducibility";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";

  outputs = {
    self,
    nixpkgs,
  }: let
    # System types to support.
    darwinSystems = ["x86_64-darwin" "aarch64-darwin"];
    # we're just going to let this in be in CI.
    # we could probably build Rstudio from scratch
    # but, I have no idea how that would do in WSL.
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    supportedSystems = darwinSystems ++ linuxSystems;

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    forDarwinSystems = nixpkgs.lib.genAttrs darwinSystems;
    forLinuxSystems = nixpkgs.lib.genAttrs linuxSystems;

    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});

    # what R packages are we going to use?

    usesRPackages = (
      pkgs: with pkgs.rPackages; [
        commonmark
        tidyverse
        rmarkdown
        markdown
        knitr
      ]
    );

    # at the very least local development packages
    uses = (
      pkgs:
        (with pkgs; [gnumake starship R pandoc just texlive.combined.scheme-full])
        ++ (usesRPackages pkgs)
    );
  in {
    packages = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        r-markdown-html = pkgs.stdenv.mkDerivation {
          name = "knit-rmd-files";
          srcs = [
            # list your rmd files that
            # you would like to knit and upload.
          ];

          # we're going to split it up into two phases,
          # building and installing
          phases = ["buildPhase" "installPhase"];

          # note pulling in the development
          # dependencies would be time consuming, so
          # we're just going to be careful to check locally.
          buildInputs = with pkgs; [R pandoc] ++ (usesRPackages pkgs);

          # how do we knit rmd files? Like so.
          buildPhase = ''
            function knit() {
              ${pkgs.R}/bin/R -e "rmarkdown::render('$1', output_file=\"$2\")"
            }


            for src in $srcs; do
              knit $src $(pwd)/$(basename $src .Rmd | cut -d '-' -f2).html
            done
          '';

          # Move the R markdown files to a good directory.
          installPhase = ''
            mkdir $out;
            cp *.html $out/
          '';
        };
      }
    );

    devShells =
      # for darwin systems, we can't
      # build RStudio, so just alias
      # the installed version.
      forDarwinSystems (system: let
        pkgs = nixpkgsFor.${system};
        buildInputs = uses pkgs;
      in {
        default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = ''
            export RSTUDIO_WHICH_R=${pkgs.R}/bin/R
            export RSTUDIO_PANDOC=${pkgs.pandoc}/bin/pandoc

            # you will need rstudio installed for this.
            alias rstudio='/Applications/RStudio.app/Contents/MacOS/RStudio'
          '';
        };
      })
      # for linux systems we don't want to
      # alias rstudio, this is mostly just for CI builds.
      // forLinuxSystems (
        system: let
          pkgs = nixpkgsFor.${system};
          buildInputs = uses pkgs;
        in {
          ci = pkgs.mkShell {inherit buildInputs;};
        }
      );

    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);
  };
}
