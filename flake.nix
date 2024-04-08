{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, nixpkgs-unstable, ...}:
    flake-utils.lib.eachDefaultSystem (system: 
      let

        pkgs = import nixpkgs {
          inherit system;
        };

        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
        };


      in
      {
        devShells.notebook = import ./notebooks { nixpkgs=pkgs; };
        devShells.python = import ./scripts { nixpkgs=pkgs; };
      }
    );
}
