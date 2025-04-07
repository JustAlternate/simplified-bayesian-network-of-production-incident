with import <nixpkgs> { };

let
  pythonPackages = python311Packages;
in
pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    # Explicitly include GCC and its libraries
    gcc
    gcc.cc.lib # Ensure libgomp is available

    graphviz
    python3
    pythonPackages.python
    pythonPackages.ipykernel
    pythonPackages.jupyterlab
    pythonPackages.pyzmq
    pythonPackages.venvShellHook
    pythonPackages.pip
    pythonPackages.numpy
    pythonPackages.pandas
    pythonPackages.requests

    taglib
    openssl
    git
    libxml2
    libxslt
    libzip
    zlib
  ];

  # Add autoPatchelfHook to fix library paths automatically
  nativeBuildInputs = [
    autoPatchelfHook
  ];

  # Set library path for OpenMP
  shellHook = ''
    export LD_LIBRARY_PATH=${gcc.cc.lib}/lib:$LD_LIBRARY_PATH
  '';

  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    python -m ipykernel install --user --name=numpy-env --display-name="project-env"
    pip install -r requirements.txt
  '';

  postShellHook = ''
    unset SOURCE_DATE_EPOCH
  '';
}
