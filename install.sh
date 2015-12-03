#!/usr/bin/env sh

PRELUDE_URL="https://github.com/bbatsov/prelude.git"
PRELUDE_INSTALL_DIR="$HOME/.emacs.d"
FISK_EMACS_URL="https://github.com/fisk/emacs-distro.git"
FISK_EMACS_INSTALL_DIR="$PRELUDE_INSTALL_DIR/personal/emacs-distro"

# Install Prelude
curl -L https://git.io/epre | sh

# Get default prelude-modules file
cp "$PRELUDE_INSTALL_DIR/sample/prelude-modules.el" "$PRELUDE_INSTALL_DIR/"
cp "$FISK_EMACS_INSTALL_DIR/boot-personal.el" "$PRELUDE_INSTALL_DIR/personal/boot-personal.el"

# Clone personal repo
/usr/bin/env git clone $FISK_EMACS_URL "$FISK_EMACS_INSTALL_DIR"

