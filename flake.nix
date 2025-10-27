{
  description = "A project by ?.";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/*.tar.gz";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
      ];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;
        devshells.default = {
          devshell.motd = ''

            {bold}Welcome to this project's devshell!{reset}

            This project uses {bold}just{reset} as its {italic}command runner{reset}.
            See all available recipes by running:

            ''$ {bold}just --list{reset}

            $(just --list)
          '';
          env = [
            # { name = "MY_ENV_VAR"; value = "SOTRUE"; }
          ];
          packages = with pkgs; [
            nixfmt-rfc-style

            just
            concurrently

            racket
            nodejs_24
            typescript
            typescript-language-server

            zulu

            python3
            presenterm
          ];
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
