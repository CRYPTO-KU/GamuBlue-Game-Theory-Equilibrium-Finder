{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wrapGAppsHook,
  wxGTK32,
  glib,
  ...
}:
stdenv.mkDerivation {
  pname = "gambit";
  version = "2023-09-11";
  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "021198c7ede9563ff4b8c9f58d5aae19b55b634e";
    sha256 = "sha256-MTcQYlJZD2RiGoephmrasY9DeSaISIYLSSisFCuYkBo=";
  };
  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook
  ];
  buildInputs = [
    wxGTK32
    glib
  ];
}
