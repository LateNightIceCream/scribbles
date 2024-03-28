{ nixpkgs }:

let
  pkgs = nixpkgs;
  my-python = pkgs.python311;

  # pypi packages installed by pip
  requirements = ''
    numpy
    scipy
    notebook==7.1.2
    ipython==8.22.2 
  '';

  mkPipInstallCommand = pkg: if pkg == "" then "" else "pip install ${pkg}";
  installCommands = pkgs.lib.concatMapStringsSep "\n" mkPipInstallCommand (pkgs.lib.splitString "\n" requirements);

in
pkgs.mkShell rec {

  venvDir = "./.venv";

  LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/";

  # this is necessary for some reason
  # otherwise the PYTHONPATH defined in the shellHook will
  # be incorrect inside the notebook
  PYTHONPATH=""; 

  packages = [

    (my-python.withPackages (python-pkgs: [
    ]))

    # This will create a venv!
    # See https://nixos.org/manual/nixpkgs/stable/#how-to-consume-python-modules-using-pip-in-a-virtual-environment-like-i-am-used-to-on-other-operating-systems
    my-python.pkgs.venvShellHook 

  ];


  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    PYTHONPATH=$PWD/src/code/notebooks/:$PWD/${venvDir}/${my-python.sitePackages}/:$PYTHONPATH
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH
  '' + installCommands + ''

    #python -m ipykernel install --user --name=${venvDir}
    jupyter-notebook

  '';
}
