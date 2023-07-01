{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "nixpkgs/23.05";
  };
  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    ardupilot-sim = with pkgs; stdenv.mkDerivation {
      pname = "ardupilot-sim";
      version = "1.0";
      src = ./.;
      dontUnpack = true;
      dontBuild = true;
      dontFixup = true;
      dontConfigure = true;
      dontPatch = true;
      nativeBuildInputs = [
      ];
      buildInputs = [
        coreutils
        git
        python311
        python311Packages.pexpect
        python311Packages.pymavlink
      ];
      installPhase = ''
        mkdir -p $out/bin

        cat << EOF > $out/bin/ardupilot-sim
        mkdir -p /tmp/ardupilot
        git clone --depth=1 https://github.com/addowhite/ardupilot /tmp/ardupilot
        cd /tmp/ardupilot
        git submodule update --init --recursive modules/waf
        git submodule update --init --recursive modules/DroneCAN
        cp -R --no-preserve=mode $out/. /tmp/ardupilot
        chmod +x /tmp/ardupilot/modules/waf/waf-light
        cd /tmp/ardupilot/Tools/autotest
        python3 sim_vehicle.py -v ArduCopter -i"1 2 3"
        EOF

        chmod +x $out/bin/ardupilot-sim
        cp -R --no-preserve=mode $src/* $out
      '';
    };
  in {
    packages.${system}.default = ardupilot-sim;
  };
}
