INSTALL_DIR="$HOME/.local"
mkdir -p "$INSTALL_DIR" && git clone https://github.com/Microsoft/vcpkg.git "$INSTALL_DIR/vcpkg" && bash "$INSTALL_DIR/vcpkg/bootstrap-vcpkg.sh"
echo "Append $INSTALL_DIR/vcpkg to your PATH."
echo "Append export VCPKG_ROOT=$INSTALL_DIR/vcpkg to your shell profile."