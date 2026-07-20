{
  description = "Ambiente para exportação de org-mode para PDF";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.default = pkgs.emacs-nox;
    packages.${system}.latexTools = pkgs.buildEnv {
      name = "org-pdf-latex-tools";
      paths = with pkgs;
        [ latexmk texliveFull ];
    };
    packages.${system}.all = pkgs.buildEnv {
      name = "org-pdf-all";
      paths = with pkgs;
        [ emacs-nox texliveFull latexmk ];
    };
  };
}
