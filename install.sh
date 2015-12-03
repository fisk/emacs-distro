#!/usr/bin/env sh

FISK_EMACS_URL="https://github.com/fisk/emacs-distro.git"
PRELUDE_URL="https://github.com/bbatsov/prelude.git"
PRELUDE_INSTALL_DIR="$HOME/.emacs.d"

# Install Prelude
curl -L https://git.io/epre | sh

# Get default prelude-modules file
cp "$PRELUDE_INSTALL_DIR/sample/prelude-modules.el" "$PRELUDE_INSTALL_DIR/"

# Clone personal repo
/usr/bin/env git clone $FISK_EMACS_URL "$PRELUDE_INSTALL_DIR/personal"

