#!/usr/bin/env sh

FISK_EMACS_URL="https://github.com/fisk/emacs-distro.git"
PRELUDE_URL="https://github.com/bbatsov/prelude.git"
PRELUDE_INSTALL_DIR="$HOME/.emacs.d"

curl -L https://git.io/epre | sh

cp "$HOME/.emacs.d/sample/prelude-modules.el" "$HOME/.emacs.d/"

/usr/bin/env git clone $FISK_EMACS_URL "$PRELUDE_INSTALL_DIR/personal"

