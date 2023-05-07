{ pkgs ? import <nixpkgs> {} }:

let
    python-packages = ps: with ps; [
        pandas
        selenium
        # other python packages

        # packages not found in nixpkgs
        (
            buildPythonPackage rec {
                pname = "webdriver_manager";
                version = "3.8.6";
                src = fetchPypi {
                    inherit pname version;
                    sha256 = "sha256-7niNOJuPRSIqimL285tXk2Ch+Hvkba1tqJkYNUrzznM=";
                };
                doCheck = false;
                propagatedBuildInputs = [
                    # Specify dependencies
                    pkgs.python3Packages.requests
                    pkgs.python3Packages.tqdm
                    pkgs.python3Packages.packaging
                    pkgs.python3Packages.python-dotenv
                ];
            }

        )
    ];
in

pkgs.mkShell {
    packages = [ 
        pkgs.google-chrome

        pkgs.python3
        (pkgs.python3.withPackages python-packages)
    ];
}

