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
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("stable" . "https://stable.melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)


;; ====================
;; Installed packages
;; ====================

(defun saint/default-font-setup ()
  (let ((font-value
         (cond
          ((eq system-type 'gnu/linux) "Monospace-10")
          ((eq system-type 'darwin) "Menlo-12")
          ((eq system-type 'windows-nt) "Consolas-10")
          (t "fixed"))))
    (add-to-list 'default-frame-alist `(font . ,font-value))
    (set-face-attribute 'default nil :font font-value)))

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
  (saint/default-font-setup)

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
  (setq indent-line-function 'insert-tab)

  :custom
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)
  (read-extended-command-predicate #'command-completion-default-include-p))

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
    (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-14"))
    (set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 140)
    (set-face-attribute 'fixed-pitch nil :family "DejaVu Sans Mono")
    (set-face-attribute 'variable-pitch nil :family "Cantarell")
    (set-frame-font "DejaVu Sans Mono 14" nil t)))
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

;; Version control
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

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

;; Delete up to to next tabstop
(use-package hungry-delete
  :ensure t
  :hook (prog-mode . hungry-delete-mode)
  :config
  (setq hungry-delete-chars-to-skip " \t"))

;; Configure Erlang
(use-package erlang-ts
  :ensure t
  :mode (("\\.erl\\'" . erlang-ts-mode)
         ("\\.hrl\\'" . erlang-ts-mode)
         ("\\.escript\\'" . erlang-ts-mode)
         ("rebar.config" . erlang-ts-mode))
  :hook (erlang-mode . (lambda ()
                         (electric-indent-local-mode t)
                         (setq indent-tabs-mode nil)
                         (setq erlang-indent-level 4)
                         (setq erlang-basic-offset 4)
                         (setq erlang-argument-indent 4)
                         (setq erlang-ts-mode-indent-offset 4)
                         (local-set-key (kbd "RET") 'newline-and-indent))))

;; Configure Elixir
(use-package elixir-ts-mode
  :ensure t
  :mode (("\\.ex\\'" . elixir-ts-mode)
         ("\\.exs\\'" . elixir-ts-mode)
         ("mix\\.lock" . elixir-ts-mode)))

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
             '(go "https://github.com/tree-sitter/tree-sitter-go.git" "v0.23.4"))
(add-to-list 'treesit-language-source-alist
             '(gomod "https://github.com/camdencheek/tree-sitter-go-mod.git" "v1.1.0"))
(add-to-list 'treesit-language-source-alist
             '(elixir "https://github.com/elixir-lang/tree-sitter-elixir.git" "v0.3.4"))

(setq saint-ts-grammers '(go gomod java kotlin elixir))
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
         (kotlin-ts-mode . eglot-ensure)
         (erlang-ts-mode . eglot-ensure))

  :custom
  (eglot-sync-connect 1)
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-connect-timeout 60)
  (eglot-events-buffer-size 0)
  (eglot-report-progress t)
  (eglot-ignored-server-capabilities nil)

  :config
  (setopt eglot-server-programs
          (assq-delete-all 'erlang-mode eglot-server-programs))
  (add-to-list 'eglot-server-programs
               '((java-mode java-ts-mode) . ("jdtls")))
  (add-to-list 'eglot-server-programs
               '((kotlin-mode kotlin-ts-mode) . ("kotlin-language-server")))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("gopls")))
  (add-to-list 'eglot-server-programs
               '((erlang-mode erlang-ts-mode) . ("elp" "server"))))

;; Configure Go
(use-package go-ts-mode
  :ensure nil
  :mode (("\\.go\\'" . go-ts-mode)
         ("go.mod" . gomod-ts-mode)
         ("go.sum" . gomod-ts-mode))
  :hook (go-ts-mode . (lambda ()
                        (setq tab-width 4)
                        (setq indent-tabs-mode t)
                        (setq go-ts-mode-indent-offset 4))))

;; Format on save
(defun saint/eglot-organize-import-and-format ()
  "Only run organize and format in prog-mode"
  (when (derived-mode-p 'prog-mode)
    (ignore-errors
      (call-interactively 'eglot-code-action-organize-imports))
    (eglot-format-buffer)))

(add-hook 'before-save-hook #'saint/eglot-organize-import-and-format)

;; Configure completion
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect 'prompt)

  :config
  (keymap-unset corfu-map "RET")

  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ("S-TAB" . corfu-previous))

  :init
  (global-corfu-mode))

(use-package corfu-terminal
  :init
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

(use-package orderless
  :custom
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

;; Override eglot flex category with orderless
(with-eval-after-load 'eglot
  (setq completion-category-defaults nil))

;; Enable cache busting, depending on if server returns
;; sufficiently many candidates
;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

;; Company mode
;; (use-package company
;;   :ensure t
;;   :hook (after-init . global-company-mode)

;;   :custom
;;   (company-idle-delay 0.1)
;;   (company-minimum-prefix-length 2)
;;   (company-tooltip-limit 15)
;;   (company-selection-wrap-around nil)
;;   (company-show-numbers t)
;;   (company-transformers '(company-sort-by-occurrence))
;;   (company-require-match nil)
;;   (company-dabbrev-ignore-case nil)
;;   (company-dabbrev-downcase nil)

;;   :config
;;   ;; Unbind Enter/Return key from company-complete-selection
;;   (define-key company-active-map (kbd "RET") nil)
;;   (define-key company-active-map (kbd "<return>") nil)
  
;;   ;; Use TAB for completion
;;   (define-key company-active-map (kbd "TAB") 'company-complete-selection)
;;   (define-key company-active-map (kbd "<tab>") 'company-complete-selection)

;;   ;; Use C-n and C-p to navigate
;;   (define-key company-active-map (kbd "C-n") 'company-select-next)
;;   (define-key company-active-map (kbd "C-p") 'company-select-previous))

;; (use-package company-box
;;   :ensure t
;;   :if (display-graphic-p)
;;   :hook (company-mode . company-box-mode))


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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
