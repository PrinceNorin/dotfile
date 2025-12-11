;; -*- lexical-binding: t; -*-

;; ====================
;; Performance settings
;; ====================
(setq gc-cons-threshold (* 50 1024 1024))
(setq read-process-output-max (* 1024 1024))
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))
(setq warning-minimum-level :error)
(setq native-comp-async-report-warnings-errors 'silent)
(setq load-prefer-newer t)


;; ====================
;; Package management
;; ====================
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("stable" . "https://stable.melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)


;; ====================
;; Installed packages
;; ====================

;; Better defaults
(use-package emacs
  :init
  ;; Clean UI
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  (blink-cursor-mode -1)

  ;; Visual
  (setq visible-bell -1)
  (setq frame-title-format '("%b - Emacs"))
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message nil)

  ;; Editing
  (delete-selection-mode t)
  (global-auto-revert-mode t)
  (electric-pair-mode t)
  (show-paren-mode t)
  (global-display-line-numbers-mode t)

  ;; Behavior
  (savehist-mode t)
  (recentf-mode t)
  (save-place-mode t)
  (global-subword-mode t)

  ;; settings
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (load custom-file 'noerror)
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq create-lockfiles nil)
  (setq use-short-answers t)

  ;; Display
  (setq display-line-numbers-type 'relative)
  (setq column-number-mode t)
  (setq line-number-mode t)

  ;; Scrolling
  (setq scroll-margin 5)
  (setq scroll-step 1)
  (setq scroll-conservatively 10000)
  (setq auto-window-vscroll nil)

  ;; Indentation
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab))

;; Better completion
(use-package vertico
  :init
  (vertico-mode +1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)))

;; Which-key
(use-package which-key
  :init
  (which-key-mode))

;; Better modeline
(use-package doom-modeline
  :init
  (doom-modeline-mode))

;; Modern theme
(use-package doom-themes
  :init
  (load-theme 'doom-one t))

;; Better fonts
(defun saint/setup-fonts ()
  "Setup fonts with fallbacks."
  (when (display-graphic-p)
    (set-face-attribute 'default nil :family "Fira Code" :height 110)
    (set-face-attribute 'fixed-pitch nil :family "Fira Code")
    (set-face-attribute 'variable-pitch nil :family "Cantarell")))
(add-hook 'after-init-hook #'saint/setup-fonts)


;; ====================
;; Editing enhancements
;; ====================

(use-package undo-fu
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(use-package expand-region
  :bind ("C-=" . er/expand-region))


;; ====================
;; Essential utilities
;; ====================

;; Project management
(use-package project
  :bind (("C-x p" . project-switch-project))
  :config
  (add-to-list 'project-vc-extra-root-markers ".git")
  (add-to-list 'project-vc-extra-root-markers "pom.xml")
  (add-to-list 'project-vc-extra-root-markers "build.gradle"))

;; Projectile
(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(defun projectile-project-root-marker (dir)
  "Check for a custom .git root marker in DIR."
  (when (file-exists-p (expand-file-name ".git" dir))
    dir))

(add-to-list 'projectile-project-root-files-functions #'projectile-project-root-marker)

;; Magit
(use-package magit
  :bind ("C-x g" . magit-status))

;; Terminal in Emacs
(use-package vterm
  :commands vterm)

;; Better window management
(use-package winner
  :init
  (winner-mode))


;; ====================
;; Programming setup
;; ====================

;; Configure Kotlin
(use-package kotlin-ts-mode
  :ensure t
  :mode ("\\.kt\\'" "\\.kts\\'")
  :config
  (setq kotlin-tab-width 4)
  (setq indent-tabs-mode nil))

;; Treesitter
(use-package treesit-auto
  :init
  (setq treesit-font-lock-level 4)
  :config
  (global-treesit-auto-mode))

(add-to-list 'treesit-language-source-alist
             '(java "https://github.com/tree-sitter/tree-sitter-java.git" "v0.23.5"))
(add-to-list 'treesit-language-source-alist
             '(kotlin "https://github.com/fwcd/tree-sitter-kotlin.git" "0.3.8"))
(add-to-list 'treesit-language-source-alist
             '(go "https://github.com/tree-sitter/tree-sitter-go.git" "v0.19.1"))
(add-to-list 'treesit-language-source-alist
             '(gomod "https://github.com/camdencheek/tree-sitter-go-mod.git" "v1.1.0"))

(setq saint-ts-grammers '(go gomod java kotlin))
(setq saint-ts-install-path
  (expand-file-name "tree-sitter" user-emacs-directory))

(defun saint/treesit-ensure-grammers-install ()
  "Install grammers define in variable above."
  (interactive)
  (dolist (lang saint-ts-grammers)
    (saint/treesit-ensure-grammer-install lang)))

(defun saint/treesit-ensure-grammer-install (lang)
  "Ensure a specific grammer is installed."
  (unless (treesit-language-available-p lang)
    (unless (saint/treesit-grammer-installed-p lang)
      (message "tree-sitter grammer for %s not found, installing..." lang)
      (treesit-install-language-grammar lang))))

(defun saint/treesit-grammer-installed-p (lang)
  "Check if grammer has already been installed."
  (let* ((lang-file-name (concat "libtree-sitter-" (symbol-name lang) ".so"))
        (lang-file-path (expand-file-name lang-file-name saint-ts-install-path)))
    (file-exists-p lang-file-path)))

(add-hook 'emacs-startup-hook 'saint/treesit-ensure-grammers-install)

;; Eglot language server
(use-package eglot
  :hook ((python-ts-mode . eglot-ensure)
         (go-ts-mode . eglot-ensure)
         (javascript-ts-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (java-ts-mode . eglot-ensure)
         (kotlin-ts-mode . eglot-ensure))

  :custom
  (eglot-events-buffer-size 0)
  (eglot-report-progress nil)
  (eglot-ignored-server-capabilities nil)

  :config
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) . ("jdtls")))
  (add-to-list 'eglot-server-programs
               '((kotlin-mode kotlin-ts-mode) . ("kotlin-language-server")))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("gopls"))))

;; Configure Go
(use-package go-ts-mode
  :ensure nil
  :hook (go-ts-mode . (lambda ()
                        (setq tab-width 4)
                        (setq indent-tabs-mode t)
                        (setq go-ts-mode-indent-offset 4))))

;; Format on save
(with-eval-after-load 'eglot
  (add-hook 'after-save-hook #'eglot-format nil t))

;; Company mode
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)

  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 2)
  (company-tooltip-limit 15)
  (company-selection-wrap-around t)
  (company-show-numbers t)
  (company-transformers '(company-sort-by-occurrence))
  (company-require-match nil)
  (company-dabbrev-ignore-case nil)
  (company-dabbrev-downcase nil)

  :config
  ;; Use TAB for completion
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection)

  ;; Use C-n and C-p to navigate
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package company-box
  :ensure t
  :if (display-graphic-p)
  :hook (company-mode . company-box-mode))


;; =====================
;; Keybindings
;; =====================

;; Easier window navigation
(global-set-key (kbd "M-o") 'other-window)

;; QUickly open config
(defun saint/open-config ()
  "Open Emacs configuration."
  (interactive)
  (find-file user-init-file))
(global-set-key (kbd "C-c e") 'saint/open-config)

;; Reload config
(defun saint/reload-config ()
  "Reload Emacs configuration."
  (interactive)
  (load-file user-init-file))
(global-set-key (kbd "C-c r") 'saint/reload-config)


;; Set UTF-8 as default encoding
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Auto-revert files when changed externally
(setq global-auto-revert-non-file-buffers t)

;; Smooth scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

;; Don't show *Messages* buffer on startup
(setq initial-buffer-choice t)

(provide 'init)
