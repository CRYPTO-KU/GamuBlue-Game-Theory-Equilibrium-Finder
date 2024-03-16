{
  buildPythonPackage,
  pytest,
  cython,
  lxml,
  numpy,
  scipy,
  fetchFromGitHub,
  ...
}:
buildPythonPackage {
  pname = "gambit";
  version = "2022-09-11";
  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "6f7455c088b0e29141e762571ba9997d9da3e589";
    sha256 = "sha256-LDSVeyRWNfyTdeQG7DI9FM6xRlZNtVdHYCP6pcmWveA=";
  };
  propagatedBuildInputs = [pytest cython lxml numpy scipy];
}
