#!/bin/bash

echo -e "\n\033[0;94m=+=+=+=+=+= Building latest NEOVIM nightly; $(date) =+=+=+=+=+=\033[0m\n"

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

info "Checking out latest nightly"
git fetch --all --tags
git checkout tags/nightly -b nightly-build

info "Cleaning up build dir"
rm -rf build

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
