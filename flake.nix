{
  description = "web-security: boot.dev course";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # `nix develop` - reproducible dev environment.
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Go toolchain
            go
            gopls
            gotools
            golangci-lint
            govulncheck
            wgo # file-watch live reload for `make watch`

            # Database tools
            # goose
            # sqlc
            # postgresql_18
          ];

          shellHook = ''
            # export JWT_SECRET="dev-only-change-me"
            # export GOFLAGS="-mod=readonly"
            # The flake's go_1_27 is the only toolchain; fail loudly rather than
            # silently downloading one if go.mod ever outruns nixpkgs.
            export GOTOOLCHAIN="local"
            echo "web-security dev shell"
            echo "  go:        $(go version | cut -d' ' -f3)"
            echo ""
          '';
        };

      }
    );
}
