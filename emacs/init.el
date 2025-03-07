;;; init.el --- Full configuration file -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstrap the configuration for emacs
;; when it start up.

;;; Code:

;; Produce backtraces when errors occur, set to `t' to turn it on
(setq debug-on-error nil)

(let ((minver "27.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requries v%s or higher" minver)))
(when (version< emacs-version "28.1")
  (message "Your Emacs is too old, and some functionality in this config will be disabled. Please upgrade if possible."))

;; Adjust garbage collection threshold for early startup (see use of gcmh below)
(setq gc-cons-threshold (* 128 1024 1024))

;; Process performance tuning

(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)

;; Package management

(require 'package)
(setq package-user-dir
      (expand-file-name (format "elpa-%s.%s" emacs-major-version emacs-minor-version)
                        user-emacs-directory))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-unsigned-archives "melpa")
;; Official MELPA Mirror, in case necessary.
;;(add-to-list 'package-archives (cons "melpa-mirror" (concat proto "://www.mirrorservice.org/sites/melpa.org/packages/")) t)

;; Work-around for https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341
(when (and (version< emacs-version "26.3") (boundp 'libgnutls-version) (>= libgnutls-version 30604))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

(setq package-enable-at-startup nil)
(setq package-native-compile t)
(package-initialize)

(defvar custom-packages
  '(vertico treesit-auto company)
  "A list of packages to ensure are installed at launch.")

(defun custom-packages-installed-p()
  (cl-loop for p in custom-packages
           when (not (package-installed-p p)) do (cl-return nil)
           finally (cl-return t)))

(unless (custom-packages-installed-p)
  ;; Check for new packages (package versions)
  (package-refresh-contents)
  ;; Install the missing packages
  (dolist (p custom-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(require 'vertico)
(vertico-mode)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; Treesit
(require 'treesit-auto)
;; (setq treesit-auto-langs '(c c++ go))
(setq treesit-auto-install 'prompt)

(setq custom-go-ts-config
      (make-treesit-auto-recipe
        :lang 'go
        :ts-mode 'go-ts-mode
        :remap '(go-mode)
        :url "github.com/tree-sitter/tree-sitter-go"
        :revision "v0.23.4"
        :source-dir "src"
        :ext "\\.go\\'"))

(add-to-list 'treesit-auto-recipe-list custom-go-ts-config)
(global-treesit-auto-mode)
(treesit-auto-add-to-auto-mode-alist 'all)

;; General settings

;; Disable toolbars
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(setq visible-bell 1)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)

(setq-default
 blink-cursor-interval 0.4
 buffers-menu-max-size 30
 ediff-split-window-function 'split-window-horizontally
 ediff-window-setup-function 'ediff-setup-windows-plain
 indent-tabs-mode nil
 create-lockfiles nil
 auto-save-default nil
 make-backup-files nil
 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
 scroll-preserve-screen-position 'always
 set-mark-command-repeat-pop t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil)

(defun custom/prog-mode-default-settings()
  (electric-pair-mode t)
  (display-line-numbers-mode))

(add-hook 'prog-mode-hook 'custom/prog-mode-default-settings)

;; Custom font
(set-frame-font "Consolas 12" nil t)

;; Disable backup file
(setq make-backup-file nil)

;; Custom themes directory
(add-to-list 'custom-theme-load-path
             (concat user-emacs-directory "themes"))

(load-theme 'timu-spacegrey t)

;; Enable built-in and pre-installed TS modes if the grammars are available

;; (defun sanityinc/auto-configure-treesitter ()
;;   "Find and configure installed grammars, remap to matching -ts-modes if present.
;; Return a list of languages seen along the way."
;;   (let ((grammar-name-to-emacs-lang '(("c-sharp" . "csharp")
;;                                       ("cpp" . "c++")
;;                                       ("gomod" . "go-mod")
;;                                       ("javascript" . "js")))
;;         seen-grammars)
;;     (dolist (dir (cons (expand-file-name "tree-sitter" user-emacs-directory)
;;                        treesit-extra-load-path))
;;       (when (file-directory-p dir)
;;         (dolist (file (directory-files dir))
;;           (let ((fname (file-name-sans-extension (file-name-nondirectory file))))
;;             (when (string-match "libtree-sitter-\\(.*\\)" fname)
;;               (let* ((file-lang (match-string 1 fname))
;;                      (emacs-lang (or (cdr (assoc-string file-lang grammar-name-to-emacs-lang)) file-lang)))
;;                 ;; Override library if its filename doesn't match the Emacs name
;;                 (unless (or (memq (intern emacs-lang) seen-grammars)
;;                             (string-equal file-lang emacs-lang))
;;                   (let ((libname (concat "tree_sitter_" (replace-regexp-in-string "-" "_" file-lang))))
;;                     (add-to-list 'treesit-load-name-override-list
;;                                  (list (intern emacs-lang) fname libname))))
;;                 ;; If there's a corresponding -ts mode, remap the standard mode to it
;;                 (let ((ts-mode-name (intern (concat emacs-lang "-ts-mode")))
;;                       (regular-mode-name (intern (concat emacs-lang "-mode"))))
;;                   (when (fboundp ts-mode-name)
;;                     (message "init-treesitter: using %s in place of %s" ts-mode-name regular-mode-name)
;;                     (add-to-list 'major-mode-remap-alist
;;                                  (cons regular-mode-name ts-mode-name))))
;;                 ;; Remember we saw this language so we don't squash its config when we
;;                 ;; find another lib later in the treesit load path
;;                 (push (intern emacs-lang) seen-grammars)))))))
;;     seen-grammars))
;;
;; (sanityinc/auto-configure-treesitter)

;;; Support remapping of additional libraries

(defun sanityinc/remap-ts-mode (non-ts-mode ts-mode grammar)
  "Explicitly remap NON-TS-MODE to TS-MODE if GRAMMAR is available."
  (when (and (fboundp 'treesit-ready-p)
             (treesit-ready-p grammar t)
             (fboundp ts-mode))
    (add-to-list 'major-mode-remap-alist (cons non-ts-mode ts-mode))))

;; When there's js-ts-mode, we also prefer it to js2-mode
(sanityinc/remap-ts-mode 'js2-mode 'js-ts-mode 'javascript)

;; Default
(setq treesit-font-lock-level 4)


;;; Programming language setting

;; C/C++
(setq-default
 c-default-style "linux"
 c-basic-offset 4
 c-ts-mode-indent-offset 4
 indent-tabs-mode nil
 tab-width 4
 indent-line-function 'insert-tab)

;; Go
(setq go-ts-mode-indent-offset 4)

(add-hook 'go-ts-mode-hook 'eglot-ensure)
(add-hook 'go-ts-mode-hook '(lambda()
                              (add-hook 'before-save-hook #'eglot-format)))
(add-hook 'go-ts-mode-hook '(lambda()
                              (add-hook 'before-save-hook (lambda()
                                                            (call-interactively 'eglot-code-action-organize-imports)) nil t)))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f8d87feb627a103e0106f954a665d730eb9237beeda4c94505ceca5c546cbd9f"
     default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
