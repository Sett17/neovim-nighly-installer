#!/bin/bash

show_help() {
  echo "Usage: build_neovim.sh [TAG]"
  echo
  echo "Build and install Neovim from source."
  echo
  echo "Arguments:"
  echo "  TAG          Optional tag or commit hash to build (default: nightly)"
  echo
  echo "Options:"
  echo "  -h, --help   Show this help message"
}

TAG="${1:-nightly}"

# Handle help option
if [[ "$TAG" == "-h" || "$TAG" == "--help" ]]; then
  show_help
  exit 0
fi

echo -e "\n\033[0;94m=+=+=+=+=+= Building NEOVIM from tag/commit '$TAG'; $(date) =+=+=+=+=+=\033[0m\n"

info() {
  echo -e "\033[0;94mINFO: \033[0m$1"
}
error() {
  echo -e "\033[0;91mERROR: \033[0m$1"
}

cd source

info "Clean up build branch"
git checkout master
git branch -D nightly-build 2>/dev/null

info "Checking out tag/commit '$TAG'"
git fetch --tags

if git rev-parse "$TAG" >/dev/null 2>&1; then
  git checkout "$TAG" -b nightly-build
else
  error "Tag/commit '$TAG' not found."
  exit 1
fi

info "Cleaning up CMake cache and build directories"
rm -rf build
rm -rf .deps/build

info "Building Neovim from source..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

info "Creating DEB package..."
cd build
cpack -G DEB

DEB_PACKAGE="./nvim-linux64.deb"
info "DEB package @ $DEB_PACKAGE"

if [ ! -f "$DEB_PACKAGE" ]; then
  error "DEB package creation failed."
  exit 1
else
  info "Installing DEB package: $DEB_PACKAGE"
  sudo dpkg -i "$DEB_PACKAGE"
fi

info "Neovim installation complete."
