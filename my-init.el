;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; My emacs config file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-splash-screen t)

(require 'package)
(require 'prelude-packages)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

defvar my-packages
  '(ace-jump-mode
    ack
    ag
    s
    dash
    anzu
    auto-complete-c-headers
    auto-complete
    popup
    auto-complete-clang
    auto-complete
    popup
    better-defaults
    buffer-move
    color-theme-sanityinc-solarized
    color-theme-solaried
    color-theme
    company-irony
    irony
    company
    dash-functional
    dash
    diminish
    dired+
    dirtree
    windata
    tree-mode
    drag-stuff
    ecb
    ecb-snapshot
    elisp-slime-nav
    elscreen
    eshell-prompt-extras
    evil-leader
    evil
    goto-chg
    undo-tree
    exec-path-from-shell
    f
    dash
    s
    find-file-in-project
    swiper
    fiplr
    grizzl
    flx-ido
    flx
    flycheck-color-mode-line
    dash
    flycheck
    seq
    let-alist
    pkg-info
    epl
    dash
    flycheck-irony
    irony
    flycheck
    seq
    let-alist
    pkg-info
    epl
    dash
    flyspell-lazy
    git-commit-mode
    git-rebase-mode
    goto-chg
    grizzl
    helm-ag
    helm
    helm-core
    async
    async
    helm-ag-r
    helm
    helm-core
    async
    async
    helm-git
    helm-make
    projectile
    pkg-info
    epl
    dash
    helm
    helm-core
    async
    async
    helm-projectile
    dash
    projectile
    pkg-info
    epl
    dash
    helm
    helm-core
    async
    async
    highlight-symbol
    iedit
    irony
    latex-extra
    auctex
    latex-pretty-symbols
    let-alist
    load-theme-buffer-local
    magit-filenotify
    magit
    magit-popup
    dash
    async
    git-commit
    with-editor
    dash
    async
    dash
    with-editor
    dash
    async
    dash
    async
    magit-popup
    dash
    async
    monky
    move-line
    move-text
    multi-eshell
    multiple-cursors
    neotree
    nlinum
    noflet
    popup-complete
    popup
    popwin
    projectile
    pkg-info
    epl
    dash
    rich-minority
    rtags
    s
    seq
    slime
    solarized-theme
    dash
    swiper
    tabbar-ruler
    tabbar
    tree-mode
    undo-tree
    wgrep-ag
    wgrep
    wgrep-helm
    wgrep
    windata
    with-editor
    dash
    async yasnippet)
  "A list of packages to ensure are installed at launch.")

(defun install-my-packages ()
  "Install all packages listed in `my-packages'."
  (unless (my-packages-installed-p)
    ;; check for new packages (package versions)
    (message "%s" "Emacs is now refreshing its package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    ;; install the missing packages
    (prelude-require-packages my-packages)))

;; run package installation
(install-my-packages)

;; activate installed packages
(package-initialize)

(provide 'my-packages)

(setq url-http-attempt-keepalives nil)

;; random stuff

(setq ag-arguments (list "--smart-case" "--nogroup" "--column"))

(setq wgrep-auto-save-buffer t)
(setq wgrep-enable-key (kbd "C-c C-p"))

(prefer-coding-system 'utf-8)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Macports support
(setenv "PATH"
  (concat
   "/opt/local/bin" ":"
   (getenv "PATH")
  )
)

(load "elscreen" "ElScreen")

(require 'wgrep)
(require 'wgrep-helm)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(exec-path-from-shell-copy-env "LANG")
(exec-path-from-shell-copy-env "PS1")
(exec-path-from-shell-copy-env "CLICOLOR")
(exec-path-from-shell-copy-env "CLICOLOR_FORCE")

(setq shell-file-name "bash")
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name  shell-file-name) ; Interactive shell
(setq ediff-shell               shell-file-name)    ; Ediff shell
(setq explicit-shell-args       '("--login" "-i"))

(setq ag-reuse-buffers t)

(add-hook 'eshell-preoutput-filter-functions 'ansi-color-filter-apply)

(setq eshell-prompt-function (lambda nil
    (concat
     (propertize "[" 'face `(:foreground "red"))
     (propertize user-login-name 'face `(:foreground "red"))
     (propertize ":" 'face `(:foreground "red"))
     (propertize (eshell/pwd) 'face `(:foreground "red"))
     (propertize "]" 'face `(:foreground "red"))
     (propertize " $ " 'face `(:foreground "red")))))

(setq eshell-highlight-prompt nil)

(require 'better-defaults)

(load-file "/Users/fisk/Documents/programming/dvc/dvc-load.el")
(setq monky-process-type 'cmdserver)

;; Elisp go-to-definition with M-. and back again with M-,
(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t)))
(eval-after-load 'elisp-slime-nav '(diminish 'elisp-slime-nav-mode))

(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
	"Show line numbers temporarily, while prompting for the line number input"
	(interactive)
	(unwind-protect
		(progn
			(nlinum-mode 1)
			(goto-line (read-number "Goto line: ")))
	    (nlinum-mode -1)))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))


(require 'dirtree)

;; anzu mode for showing number of search hits
(global-anzu-mode +1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(require 'vc-hg)
(defun vc-hg-annotate-command (file buffer &optional revision)
	  "Execute \"hg annotate\" on FILE, inserting the contents in BUFFER.
Optional arg REVISION is a revision to annotate from."
		(vc-hg-command buffer 0 file "annotate" "-d" "-n" "--follow"
									                  (when revision (concat "-r" revision))))

;; Support copy/paste
(defun pbcopy ()
  (interactive)
  (call-process-region (point) (mark) "pbcopy")
  (setq deactivate-mark t))

(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

(defun pbcut ()
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))

;; copy paste
(global-set-key (kbd "C-c c") 'pbcopy)
(global-set-key (kbd "C-c v") 'pbpaste)
(global-set-key (kbd "C-c x") 'pbcut)

;; don't put popups on the right
(setq split-height-threshold nil)
(setq split-width-threshold most-positive-fixnum)

;; projectile
(projectile-global-mode)
(setq projectile-indexing-method 'native)
(setq projectile-enable-caching t)
(global-set-key [f9] 'helm-projectile)
(global-set-key [f8] 'helm-imenu)

;; Enable mouse support
(if (display-graphic-p)
  (progn
    (global-nlinum-mode t)
    (x-focus-frame nil)
  )
  (progn
    (require 'mouse)
    (require 'mwheel)
    (xterm-mouse-mode t)
    (mouse-wheel-mode t)

    (defun x-select-text (text))
    (setq x-select-enable-clipboard nil)
    (setq x-select-enable-primary nil)
    (setq mouse-drag-copy-region nil)

    (defun track-mouse (e))
    (setq mouse-sel-mode t)

    (define-key input-decode-map "\e[1;9A" [M-up])
    (define-key input-decode-map "\e[1;9B" [M-down])
    (define-key input-decode-map "\e[1;9C" [M-right])
    (define-key input-decode-map "\e[1;9D" [M-left])

    (define-key input-decode-map "\e[1;2A" [S-up])
    (define-key input-decode-map "\e[1;2B" [S-down])
    (define-key input-decode-map "\e[1;2C" [S-right])
    (define-key input-decode-map "\e[1;2D" [S-left])

    (define-key input-decode-map "\e[1;6A" [C-S-up])
    (define-key input-decode-map "\e[1;6B" [C-S-down])
    (define-key input-decode-map "\e[1;6C" [C-S-right])
    (define-key input-decode-map "\e[1;6D" [C-S-left])
  )
)

(setq redisplay-dont-pause t)
(setq scroll-margin 1)
(setq scroll-step 1)
(setq scroll-conservatively 10000)

(add-to-list 'default-frame-alist '(font .  "Inconsolata for Powerline-14" ))
(set-face-attribute 'default t :font  "Inconsolata for Powerline-14" )

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed t)

;; General tweaks
(setq default-tab-width 2)
(setq-default indent-tabs-mode nil)

;(transient-mark-mode t)

;; ido
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(icomplete-mode t)

;; drag stuff
(drag-stuff-global-mode t)

;; helm
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)

(require 'popwin)
(popwin-mode 1)

(setq neo-window-width 50)

(require 'neotree)
(global-set-key [f7] 'neotree-toggle)

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ffip-project-root))
        (file-name (buffer-file-name)))
    (if project-dir
        (progn
          (neotree-dir project-dir)
          (neotree-find file-name))
      (message "Could not find git project root."))))

(when neo-persist-show
  (add-hook 'popwin:before-popup-hook
            (lambda () (setq neo-persist-show nil)))
  (add-hook 'popwin:after-popup-hook
                          (lambda () (setq neo-persist-show t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ stuff
(require 'cc-mode)

(defun use-rtags (&optional useFileManager)
  (and (rtags-executable-find "rc")
       (cond ((not (gtags-get-rootpath)) t)
             ((and (not (eq major-mode 'c++-mode))
                   (not (eq major-mode 'c-mode))) (rtags-has-filemanager))
             (useFileManager (rtags-has-filemanager))
             (t (rtags-is-indexed)))))

(defun tags-find-symbol-at-point (&optional prefix)
  (interactive "P")
  (if (and (not (rtags-find-symbol-at-point prefix)) rtags-last-request-not-indexed)
      (gtags-find-tag)))
(defun tags-find-references-at-point (&optional prefix)
  (interactive "P")
  (if (and (not (rtags-find-references-at-point prefix)) rtags-last-request-not-indexed)
      (gtags-find-rtag)))
(defun tags-find-symbol ()
  (interactive)
  (call-interactively (if (use-rtags) 'rtags-find-symbol 'gtags-find-symbol)))
(defun tags-find-references ()
  (interactive)
  (call-interactively (if (use-rtags) 'rtags-find-references 'gtags-find-rtag)))
(defun tags-find-file ()
  (interactive)
  (call-interactively (if (use-rtags t) 'rtags-find-file 'gtags-find-file)))
(defun tags-imenu ()
  (interactive)
  (call-interactively (if (use-rtags t) 'rtags-imenu 'idomenu)))

(define-key c-mode-base-map (kbd "C-x s s") (function rtags-find-symbol-at-point))
(define-key c-mode-base-map (kbd "C-x s r") (function rtags-find-references-at-point))
(define-key c-mode-base-map (kbd "C-x s f") (function rtags-find-file))
(define-key c-mode-base-map (kbd "C-x s S") (function rtags-find-symbol))
(define-key c-mode-base-map (kbd "C-x s R") (function rtags-find-references))
(define-key c-mode-base-map (kbd "C-x s v") (function rtags-find-virtuals-at-point))
(define-key c-mode-base-map (kbd "C-x s i") (function rtags-imenu))

(require 'rtags)
(require 'company-rtags)

(rtags-enable-standard-keybindings c-mode-base-map)
(setq rtags-completions-enabled t)

(global-company-mode t)

(add-to-list 'company-backends 'company-rtags)
(setq company-rtags-begin-after-member-access t)

(rtags-diagnostics t)

(set-process-query-on-exit-flag rtags-diagnostics-process nil)
(add-hook 'kill-emacs-hook (lambda () (rtags-stop-diagnostics)))

;; (add-hook 'c++-mode-hook 'company-mode)
;; (add-hook 'c-mode-hook 'company-mode)
;; (add-hook 'objc-mode-hook 'company-mode)



;(require 'irony-flycheck)

;; (setq-default c-basic-offset 2 c-default-style "linux")
;; (setq-default tab-width 2 indent-tabs-mode t)
;; (define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
;;
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;;
;; (add-hook 'c++-mode-hook 'flycheck-mode)
;; (add-hook 'c-mode-hook 'flycheck-mode)
;; (add-hook 'objc-mode-hook 'flycheck-mode)
;;
;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;; 	(define-key irony-mode-map [remap completion-at-point]
;; 		'irony-completion-at-point-async)
;; 	(define-key irony-mode-map [remap complete-symbol]
;; 		'irony-completion-at-point-async))
;;
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;
;; (eval-after-load 'company
;; 	'(add-to-list 'company-backends 'company-irony))
;;
;; ;; (optional) adds CC special commands to `company-begin-commands' in order to
;; ;; trigger completion at interesting places, such as after scope operator
;; ;;     std::|
;; (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;;
;; (eval-after-load 'flycheck
;; 	'(add-to-list 'flycheck-checkers 'irony))
;;
;; (require 'flycheck-color-mode-line)
;;
;; (eval-after-load "flycheck"
;; 	'(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

;;;;; activate ecb
;;(require 'ecb)
;;;;(require 'ecb-autoloads)
;;
;;;; replace C-S-<return> with a key binding that you want
;;(require 'auto-complete-clang)
;;(define-key c++-mode-map (kbd "C-S-<return>") 'ac-complete-clang)

(show-paren-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "c5a044ba03d43a725bd79700087dea813abcb6beb6be08c7eb3303ed90782482" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" default)))
 '(rtags-completions-enabled t))

(if (display-graphic-p)
  (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
    '(comint-highlight-prompt ((t (:foreground "red" :weight bold))))
    '(helm-selection ((t (:background "#002831" :weight bold))))
    '(mode-line ((t (:foreground "#444444" :background "white"))))
    '(mode-line-inactive ((t (:foreground "#444444" :background "white"))))
    '(mode-line-buffer-id ((t (:inherit powerline-active2 :weight bold))))
    '(modeline-buffer-id-inactive ((t (:inherit powerline-inactive2 :weight bold))))
    '(powerline-active1 ((t (:inherit mode-line :foreground "#444444" :background "white"))))
    '(powerline-active2 ((t (:inherit mode-line :foreground "#1c1c1c" :background "#ff5fd7"))))
    '(powerline-inactive1 ((t (:inherit mode-line))))
    '(powerline-inactive2 ((t (:inherit mode-line)))))
  (custom-set-faces
    '(comint-highlight-prompt ((t (:foreground "red" :weight bold))))
    '(helm-selection ((t (:background "black" :weight bold))))
    '(mode-line ((t (:foreground "color-238" :background "white"))))
    '(mode-line-inactive ((t (:foreground "color-238" :background "white"))))
    '(mode-line-buffer-id ((t (:inherit powerline-active2 :weight bold))))
    '(mode-line-buffer-id-inactive ((t (:inherit powerline-inactive2 :weight bold))))
    '(powerline-active1 ((t (:inherit mode-line :foreground "color-238" :background "white"))))
    '(powerline-active2 ((t (:inherit mode-line :foreground "color-234" :background "color-206"))))
    '(powerline-inactive1 ((t (:inherit mode-line))))
    '(powerline-inactive2 ((t (:inherit mode-line))))))

(if (display-graphic-p)
  (progn
    (defface powerline-active-reverse1 '((t (:foreground "white" :background "#444444" :inherit mode-line)))
      "Powerline reverse face 1."
      :group 'powerline)

    (defface powerline-active-reverse2 '((t (:foreground "#ff5fd7" :background "#1c1c1c" :inherit mode-line)))
      "Powerline reverse face 2."
      :group 'powerline)

    (defface powerline-modified-file '((t (:background "red" :inherit mode-line)))
      "Powerline modified file cross face."
      :group 'powerline)
  )
  (progn
    (defface powerline-active-reverse1 '((t (:foreground "white" :background "color-238" :inherit mode-line)))
      "Powerline reverse face 1."
      :group 'powerline)

    (defface powerline-active-reverse2 '((t (:foreground "color-206" :background "color-234" :inherit mode-line)))
      "Powerline reverse face 2."
      :group 'powerline)

    (defface powerline-modified-file '((t (:background "red" :inherit mode-line)))
      "Powerline modified file cross face."
      :group 'powerline)
  )
)

(defface powerline-inactive-reverse1 '((t (:inherit mode-line)))
  "Powerline reverse face 1."
  :group 'powerline)

(defface powerline-inactive-reverse2 '((t (:inherit mode-line)))
  "Powerline reverse face 2."
  :group 'powerline)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTeX stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq reftex-plug-into-AUCTeX t)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)

(require 'flymake)

(defun flymake-get-tex-args (file-name)
	(list "pdflatex"
	(list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))

(add-hook 'LaTeX-mode-hook 'flymake-mode)

(setq ispell-program-name "aspell") ; could be ispell as well, depending on your preferences
(setq ispell-dictionary "english") ; this can obviously be set to any language your spell-checking program supports

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

(require 'tex)
    (TeX-global-PDF-mode t)

(defun turn-on-outline-minor-mode ()
	(outline-minor-mode 1))

(add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
(add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
(setq outline-minor-mode-prefix "\C-c \C-o") ; Or something else

;(require 'tex-site)
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase Mode" t)
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
(add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)

(setq LaTeX-eqnarray-label "eq"
			LaTeX-equation-label "eq"
			LaTeX-figure-label "fig"
			LaTeX-table-label "tab"
			LaTeX-myChapter-label "chap"
			TeX-auto-save t
			TeX-newline-function 'reindent-then-newline-and-indent
			TeX-parse-self t
			TeX-style-path
			'("style/" "auto/"
				"/usr/share/emacs21/site-lisp/auctex/style/"
				"/var/lib/auctex/emacs21/"
				"/usr/local/share/emacs/site-lisp/auctex/style/")
			LaTeX-section-hook
			'(LaTeX-section-heading
				LaTeX-section-title
				LaTeX-section-toc
				LaTeX-section-section
				LaTeX-section-label))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'evil-integration)
(require 'evil-leader)
(require 'evil)

(define-key evil-normal-state-map (kbd "RET") 'neotree-enter)

(define-key evil-normal-state-map [escape] 'evil-force-normal-state)
(define-key evil-visual-state-map [escape] 'evil-change-to-previous-state)
(define-key evil-insert-state-map [escape] 'evil-normal-state)
(define-key evil-replace-state-map [escape] 'evil-normal-state)

;; use ido to open files
(define-key evil-ex-map "e " 'ido-find-file)
(define-key evil-ex-map "b " 'ido-switch-buffer)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)

(define-key evil-motion-state-map (kbd "C-j c") #'evil-ace-jump-char-mode)
(define-key evil-motion-state-map (kbd "C-j w") #'evil-ace-jump-word-mode)

(evil-leader/set-key "c" #'evil-ace-jump-char-mode)
(evil-leader/set-key "C" #'evil-ace-jump-char-to-mode)
(evil-leader/set-key "w" #'evil-ace-jump-word-mode)
(evil-leader/set-key "l" #'evil-ace-jump-line-mode)

(evil-leader/set-key "p" 'helm-projectile)
(evil-leader/set-key "P" 'helm-imenu)

(evil-leader/set-key "o" 'previous-buffer)
(evil-leader/set-key "O" 'next-buffer)

(evil-leader/set-key "m" 'ff-find-other-file)

(evil-leader/set-key "s" 'rtags-find-symbol-at-point)
(evil-leader/set-key "r" 'rtags-find-references-at-point)
(evil-leader/set-key "f" 'rtags-find-file)
(evil-leader/set-key "S" 'rtags-find-symbol)
(evil-leader/set-key "R" 'rtags-find-references)
(evil-leader/set-key "v" 'rtags-find-virtuals-at-point)
(evil-leader/set-key "i" 'rtags-imenu)

(evil-leader/set-key "W" 'wgrep-change-to-wgrep-mode)
(evil-leader/set-key "F" 'helm-do-ag-project-root)

(global-evil-leader-mode)

(setq evil-leader/no-prefix-mode-rx '("magit-.*-mode" "gnus-.*-mode"))

(evil-leader/set-leader ",")

(define-key evil-normal-state-map (kbd "ª") 'drag-stuff-up)
(define-key evil-normal-state-map (kbd "√") 'drag-stuff-down)
(define-key evil-normal-state-map (kbd "˛") 'drag-stuff-left)
(define-key evil-normal-state-map (kbd "ﬁ") 'drag-stuff-right)

(define-key evil-normal-state-map (kbd "å") 'evil-scroll-line-up)
(define-key evil-normal-state-map (kbd "ä") 'evil-scroll-line-down)
(define-key evil-normal-state-map (kbd "Å") 'evil-scroll-page-up)
(define-key evil-normal-state-map (kbd "Ä") 'evil-scroll-page-down)

;; Make movement keys work like they should
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

;; Move between windows
(require 'buffer-move)
(global-set-key [C-w k]  'buf-move-up)
(global-set-key [C-w j]  'buf-move-down)
(global-set-key [C-w h]  'buf-move-left)
(global-set-key [C-w l]  'buf-move-right)

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; Move lines
(define-key my-keys-minor-mode-map (kbd "M-k") 'drag-stuff-up)
(define-key my-keys-minor-mode-map (kbd "M-j") 'drag-stuff-down)
(define-key my-keys-minor-mode-map (kbd "M-h") 'drag-stuff-left)
(define-key my-keys-minor-mode-map (kbd "M-l") 'drag-stuff-right)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

; Make horizontal movement cross lines
(setq-default evil-cross-lines t)

(setq-default evil-symbol-word-search t)

(require 'multiple-cursors)
(setq mc/unsupported-minor-modes '(company-mode auto-complete-mode flyspell-mode jedi-mode))
(add-hook 'multiple-cursors-mode-enabled-hook 'evil-emacs-state)
(add-hook 'multiple-cursors-mode-disabled-hook 'evil-normal-state)

	;; evil mode
(evil-mode t)

(setq evil-esc-delay 0.01)
(setq evil-want-fine-undo -1)


(defun highlight-symbol-at-point-all-windows ()
  "Toggle highlighting of the symbol at point in all windows."
  (interactive)
  (let ((symbol (highlight-symbol-get-symbol)))
    (unless symbol (error "No symbol at point"))
    (save-selected-window                           ; new
      (cl-dolist (x (window-list))                  ; new
        (select-window x)                           ; new
        (if (highlight-symbol-symbol-highlighted-p symbol)
            (highlight-symbol-remove-symbol symbol)
          (highlight-symbol-add-symbol symbol))))))

(setq highlight-symbol-idle-delay 0.3)
(add-hook 'python-mode-hook 'highlight-symbol-mode)
(add-hook 'c-mode-hook 'highlight-symbol-mode)
(add-hook 'c++-mode-hook 'highlight-symbol-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Convenient text editing stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(electric-pair-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eye candy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; highlight current line
(global-hl-line-mode t)

;; parenthesis
(show-paren-mode t)
(line-number-mode t)
(column-number-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make the fringe stand out from the background
(setq solarized-distinct-fringe-background t)

;; make the modeline high contrast
(setq solarized-high-contrast-mode-line t)
(setq x-underline-at-descent-line t)

(setq frame-background-mode 'dark)

;; set dark theme
(load-theme 'solarized-dark)
(load-theme 'solarized-dark)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Style powerline
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/vendor/powerline/")
(require 'powerline)
(require 'tramp)

(setq powerline-evil-tag-style 'verbose)

(defcustom powerline-evil-tag-style 'visual-expanded
  "The style to use for displaying the evil state tag.
Valid Values: standard, verbose, visual-expanded"
  :group 'powerline
  :type '(choice (const standard)
                 (const verbose)
                 (const visual-expanded)))

(if (display-graphic-p)
  (progn
    (defface powerline-evil-normal-face
      '((t (:foreground "#5f00d7" :inherit powerline-evil-base-face)))
      "Powerline face for evil NORMAL state."
      :group 'powerline)

    (defface powerline-evil-normal-reverse-face
      '((t (:background "#5f00d7" :inherit powerline-evil-base-reverse-face)))
      "Powerline face for evil NORMAL state."
      :group 'powerline)
  )
  (progn
    (defface powerline-evil-normal-face
      '((t (:foreground "color-56" :inherit powerline-evil-base-face)))
      "Powerline face for evil NORMAL state."
      :group 'powerline)

    (defface powerline-evil-normal-reverse-face
      '((t (:background "color-56" :inherit powerline-evil-base-reverse-face)))
      "Powerline face for evil NORMAL state."
      :group 'powerline)
  )
)
(defface powerline-evil-base-face
  '((t (:background "white" :inherit mode-line)))
  "Base face for powerline evil faces."
  :group 'powerline)

(defface powerline-evil-insert-face
  '((t (:foreground "blue" :inherit powerline-evil-base-face)))
  "Powerline face for evil INSERT state."
  :group 'powerline)

(defface powerline-evil-visual-face
  '((t (:foreground "orange" :inherit powerline-evil-base-face)))
  "Powerline face for evil VISUAL state."
  :group 'powerline)

(defface powerline-evil-operator-face
  '((t (:foreground "cyan" :inherit powerline-evil-operator-face)))
  "Powerline face for evil OPERATOR state."
  :group 'powerline)

(defface powerline-evil-replace-face
  '((t (:foreground "red" :inherit powerline-evil-base-face)))
  "Powerline face for evil REPLACE state."
  :group 'powerline)

(defface powerline-evil-motion-face
  '((t (:foreground "magenta" :inherit powerline-evil-base-face)))
  "Powerline face for evil MOTION state."
  :group 'powerline)

(defface powerline-evil-emacs-face
  '((t (:foreground "violet" :inherit powerline-evil-base-face)))
  "Powerline face for evil EMACS state."
  :group 'powerline)


(defface powerline-evil-base-reverse-face
  '((t (:foreground "white" :inherit mode-line)))
  "Base face for powerline evil faces."
  :group 'powerline)

(defface powerline-evil-insert-reverse-face
  '((t (:background "blue" :inherit powerline-evil-base-reverse-face)))
  "Powerline face for evil INSERT state."
  :group 'powerline)

(defface powerline-evil-visual-reverse-face
  '((t (:background "orange" :inherit powerline-evil-base-reverse-face)))
  "Powerline face for evil VISUAL state."
  :group 'powerline)

(defface powerline-evil-operator-reverse-face
  '((t (:background "cyan" :inherit powerline-evil-operator-reverse-face)))
  "Powerline face for evil OPERATOR state."
  :group 'powerline)

(defface powerline-evil-replace-reverse-face
  '((t (:background "red" :inherit powerline-evil-base-reverse-face)))
  "Powerline face for evil REPLACE state."
  :group 'powerline)

(defface powerline-evil-motion-reverse-face
  '((t (:background "magenta" :inherit powerline-evil-base-reverse-face)))
  "Powerline face for evil MOTION state."
  :group 'powerline)

(defface powerline-evil-emacs-reverse-face
  '((t (:background "violet" :inherit powerline-evil-base-reverse-face)))
  "Powerline face for evil EMACS state."
  :group 'powerline)

;;;###autoload
(defun powerline-evil-face ()
  "Function to select appropriate face based on `evil-state'."
  (let* ((face (intern (concat "powerline-evil-" (symbol-name evil-state) "-face"))))
    (if (facep face) face nil)))

;;;###autoload
(defun powerline-evil-reverse-face ()
  "Function to select appropriate face based on `evil-state'."
  (let* ((face (intern (concat "powerline-evil-" (symbol-name evil-state) "-reverse-face"))))
    (if (facep face) face nil)))

(defun powerline-evil-tag ()
  "Get customized tag value for current evil state."
  (let* ((visual-block (and (evil-visual-state-p)
                            (eq evil-visual-selection 'block)))
         (visual-line (and (evil-visual-state-p)
                           (eq evil-visual-selection 'line))))
    (cond ((eq powerline-evil-tag-style 'visual-expanded)
           (cond (visual-block " +V+ ")
                 (visual-line " -V- ")
                 (t evil-mode-line-tag)))
          ((eq powerline-evil-tag-style 'verbose)
           (upcase (concat (symbol-name evil-state)
                           (cond (visual-block " BLOCK")
                                 (visual-line " LINE")))))
          (t evil-mode-line-tag))))

(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
)

(defvar fisk-hg-mode nil)
(make-variable-buffer-local 'fisk-hg-mode)

(require 'vc)

(defun fisk-vc-command-hook (&rest args)
  (let ((file-name (buffer-file-name)))
   (when (and vc-mode buffer-file-name)
     (let ((backend (vc-backend buffer-file-name)))
       (when backend
         (setq fisk-hg-mode nil))))))

(add-hook 'vc-post-command-functions #'fisk-vc-command-hook)
(add-hook 'find-file-hook #'fisk-vc-command-hook)

(defun fisk-vc-info ()
  (if fisk-hg-mode fisk-hg-mode
  (let ((file-name (buffer-file-name)))
   (when (and vc-mode buffer-file-name)
     (let ((backend (vc-backend buffer-file-name)))
       (when backend
       (if (eq backend 'Hg)
         (let (
             (branch (trim-string (shell-command-to-string "hg branch")))
             (bookmark (trim-string (shell-command-to-string "hg log --template '{bookmarks}\n' -r 'bookmark() & .'"))))
           (progn
             (when (not (eq (string-width bookmark) 0))
                 (setq bookmark (format "- %s" bookmark)))
             (setq fisk-hg-mode (format " %s %s %s %s %s %s" backend (char-to-string #xe0b1) (char-to-string #xe0a0) branch bookmark (char-to-string #xe0b1)))
             fisk-hg-mode))
         (format " %s %s %s %s" backend (char-to-string #xe0b1) (vc-working-revision buffer-file-name backend) (char-to-string #xe0b1)))))))))

;;;###autoload
(defun powerline-fisk-evil-vim-color-theme ()
  "Powerline's Vim-like mode-line with evil state at the beginning in color."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (buffer-id-face (if active 'mode-line-buffer-id 'mode-line-buffer-id-inactive))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (face-reverse1 (if active 'powerline-active-reverse1 'powerline-inactive1))
                          (face-reverse2 (if active 'powerline-active-reverse2 'powerline-inactive2))
                          (evil-face (if active (powerline-evil-face) 'powerline-inactive1))
                          (evil-reverse-face (if active (powerline-evil-reverse-face) 'powerline-inactive1))
                          (powerline-modified-file-face 'powerline-modified-file)
                          (separator-left (intern (format "powerline-%s-%s"
                                                          powerline-default-separator
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           powerline-default-separator
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list
                                     (if (and active evil-mode)
                                         (concat
                                          (powerline-raw " " evil-face 'l)
                                          (powerline-raw (powerline-evil-tag) evil-face)
                                          (powerline-raw " " evil-face 'l)
                                          (funcall separator-left face-reverse1 evil-reverse-face)
                                       ))
                                     (powerline-raw " " mode-line 'l)
                                     (when (buffer-modified-p)
                                       (powerline-raw "x" powerline-modified-file-face))
                                     (when buffer-read-only
                                       (powerline-raw "[RO]" mode-line))
                                     (powerline-raw "[%z]" mode-line)
                                     (when (and (boundp 'which-func-mode) which-func-mode)
                                       (powerline-raw which-func-format nil 'l))
                                     (when (boundp 'erc-modified-channels-object)
                                       (powerline-raw erc-modified-channels-object face1 'l))
                                     (powerline-raw " " mode-line 'l)
                                     (funcall separator-left face-reverse2 face-reverse1)
                                     (powerline-raw (fisk-vc-info) face2)
                                     (powerline-raw " " face2 'l)
                                     ;(powerline-buffer-id `(mode-line-buffer-id face2) face2)
                                     ;(powerline-buffer-id buffer-id-face 'l)
                                     (powerline-raw (file-name-nondirectory buffer-file-name) buffer-id-face 'l)
                                     (powerline-raw " " face2 'l)
                                     (funcall separator-left face-reverse1 face-reverse2)
                                   ))
                          (rhs (list
                                     (funcall separator-right face-reverse2 face-reverse1)
                                     (powerline-raw "[" face2 'l)
                                     (powerline-minor-modes face2)
                                     (powerline-raw "%n" face2)
                                     (powerline-raw "]" face2)
                                     (powerline-raw " " face2 'l)
                                     (funcall separator-right evil-reverse-face face-reverse2)

                                     (powerline-raw "[" evil-face 'l)
                                     (powerline-major-mode evil-face)
                                     (powerline-process evil-face)
                                     (powerline-raw "]" evil-face)
                                     (powerline-raw (concat " " (char-to-string #xe0a1)) evil-face)
                                     (powerline-raw "%l," evil-face 'l)
                                     (powerline-raw (format-mode-line '(5 "%c")) evil-face)
                                     (powerline-raw (replace-regexp-in-string  "%" "%%" (format-mode-line '(-3 "%p"))) evil-face 'r)
                               )))
                     (concat (powerline-render lhs)
                             (powerline-fill face1 (powerline-width rhs))
                             (powerline-render rhs)))))))

(powerline-fisk-evil-vim-color-theme)

(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-highlight-prompt ((t (:foreground "red" :weight bold))))
 '(helm-selection ((t (:background "black" :weight bold))))
 '(mode-line ((t (:foreground "color-238" :background "white"))))
 '(mode-line-buffer-id ((t (:inherit powerline-active2 :weight bold))))
 '(mode-line-buffer-id-inactive ((t (:inherit powerline-inactive2 :weight bold))))
 '(mode-line-inactive ((t (:foreground "color-238" :background "white"))))
 '(powerline-active1 ((t (:inherit mode-line :foreground "color-238" :background "white"))))
 '(powerline-active2 ((t (:inherit mode-line :foreground "color-234" :background "color-206"))))
 '(powerline-inactive1 ((t (:inherit mode-line))))
 '(powerline-inactive2 ((t (:inherit mode-line))))
 '(rtags-errline ((t (:background "color-52" :underline (:color "red" :style wave)))))
 '(rtags-fixitline ((t (:underline (:color "yellow" :style wave)))))
 '(rtags-warnline ((t (:background "color-130" :underline (:color "yellow" :style wave))))))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

; Set cursor color to white
(set-cursor-color "#ffffff")
