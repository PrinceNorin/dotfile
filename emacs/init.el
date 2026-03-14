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

(when (version< emacs-version "30")
  (unless (package-installed-p 'vc-use-package)
    (package-vc-install "https://github.com/slotThe/vc-use-package"))
  (require 'vc-use-package))


;; ====================
;; Installed packages
;; ====================

;; Load Shell Variables
(use-package exec-path-from-shell
  :init
  (when (display-graphic-p)
    (exec-path-from-shell-initialize)))


;; Better GUI Font
(defun saint/default-font-setup ()
  (let ((font-name "FiraCode Nerd Font-9"))
    (add-to-list 'default-frame-alist `(font . ,font-name))
    (set-face-attribute 'default nil :font font-name)))

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
  (read-extended-command-predicate #'command-completion-default-include-p)

  :hook
  ((find-file . (lambda ()
                 (unless (derived-mode-p 'prog-mode)
                   (display-line-numbers-mode -1))))
  (prog-mode . display-line-numbers-mode)))

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

;; Configure YAML
(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'")
  :config
  (setq yaml-indent-offset 2)
  (setq treesit-indent-function 2))

(use-package yaml-pro
  :after yaml-mode
  :hook ((yaml-mode . yaml-pro-mode)
         (yaml-ts-mode . yaml-pro-mode))
  :config
  (setq yaml-pro-indent 2)
  (setq yaml-ts-indent-offset 2))

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
             '(go "https://github.com/tree-sitter/tree-sitter-go.git" "v0.20.0"))
(add-to-list 'treesit-language-source-alist
             '(gomod "https://github.com/camdencheek/tree-sitter-go-mod.git" "v1.1.0"))
(add-to-list 'treesit-language-source-alist
             '(elixir "https://github.com/elixir-lang/tree-sitter-elixir.git" "v0.3.4"))

(setq saint-ts-grammers '(python go gomod java kotlin elixir))
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
  ;; (eldoc-display-functions '(eldoc-display-in-buffer))

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

;; Trim whitespace and newline
(defun saint/cleanup-on-save ()
  "Only remove whitespace and trailing newline in prog-mode"
  (when (derived-mode-p 'prog-mode)
    ;; Delete all trailing whitespace
    (delete-trailing-whitespace)))

(add-hook 'before-save-hook #'saint/cleanup-on-save)
(add-hook 'before-save-hook #'saint/eglot-organize-import-and-format)

;; Configure completion

;; Override eglot flex category with orderless
(with-eval-after-load 'eglot
  (setq completion-category-defaults nil))

;; Enable cache busting, depending on if server returns
;; sufficiently many candidates
;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-preselect 'prompt)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  (corfu-quit-at-boundary t)
  (corfu-quit-no-match t)
  (corfu-no-exact-match nil)

  :bind
  (:map corfu-map
        ("C-p" . nil)
        ("C-n" . nil)
        ("TAB" . corfu-next)
        ("S-TAB" . corfu-previous)
        ("RET" . corfu-complete-or-newline))

  :init
  (global-corfu-mode))

(defun corfu-complete-or-newline ()
  "If a candiate is selected, complete it. Otherwise insert a newline"
  (interactive)
  (if (and (bound-and-true-p corfu-mode)
           corfu--candidates
           corfu--index
           (>= corfu--index 0))
      (corfu-complete)
    (newline)))

;; Configure AI code completion
(use-package dash
  :ensure t)

(use-package plz
  :ensure t
  :config
  (setq plz-connect-timeout 10)
  (setq plz-read-timeout 30))

(use-package minuet
  :after corfu
  :config
  ;; Set the provider to OpenAI FIM compatible
  (setq minuet-provider 'openai-fim-compatible)

  ;; Recommended for local models to save resources
  (setq minuet-n-completions 1)

  ;; Start with a moderate context window
  (setq minuet-context-window 512)

  ;; --- Docker Model Runner Configuration ---
  (plist-put minuet-openai-fim-compatible-options
             :end-point "http://localhost:12434/engines/llama.cpp/v1/completions")

  ;; Friendly name for the provider
  (plist-put minuet-openai-fim-compatible-options
             :name "Docker-Model-Runner")

  ;; No API key needed for local Docker Model Runner
  (plist-put minuet-openai-fim-compatible-options
             :api-key "TERM")  ; Just a placeholder

  ;; Model name - use the one from your Docker Model Runner
  (plist-put minuet-openai-fim-compatible-options
             :model "huggingface.co/microsoft/phi-3-mini-4k-instruct-gguf")  ; or whatever model name you're using

  ;; Optional: adjust timeout if needed (in seconds)
  (setq minuet-request-timeout 5)

  :bind (("M-i" . #'minuet-show-suggestion) ;; Example: manually trigger a suggestion
         :map minuet-active-mode-map
         ("<tab>" . #'minuet-accept-suggestion-line) ;; Accept the first line of the suggestion with Tab
         ("M-A" . #'minuet-accept-suggestion)        ;; Accept the whole suggestion
         ("M-n" . #'minuet-next-suggestion)          ;; Cycle to next suggestion
         ("M-p" . #'minuet-previous-suggestion)      ;; Cycle to previous suggestion
         ("M-e" . #'minuet-dismiss-suggestion)))     ;; Dismiss the suggestion

;; Company mode
;; (use-package company
;;   :ensure t
;;   :hook (after-init . global-company-mode)

;;   :custom
;;   (company-idle-delay 0.2) ;; Enable auto complete
;;   (company-minimum-prefix-length 1)
;;   (company-tooltip-limit 15)
;;   (company-selection-wrap-around t)

;;   (company-auto-select nil)
;;   (company-auto-select-p nil)

;;   (company-auto-complete nil)
;;   (company-auto-complete-chars nil)
;;   (company-require-match 'never)

;;   (company-show-numbers t)
;;   (company-transformers '(company-sort-by-occurrence))
;;   (company-require-match nil)
;;   (company-dabbrev-ignore-case nil)
;;   (company-dabbrev-downcase nil)

;;   (company-backends '((company-capf company-dabbrev-code)))

;;   :config
;;   (define-key company-active-map (kbd "RET") 'company-complete-selection)
;;   (define-key company-active-map (kbd "<return>") 'company-complete-selection)

;;   ;; Use TAB to select next candidate
;;   (define-key company-active-map (kbd "TAB") 'company-select-next)
;;   (define-key company-active-map (kbd "<tab>") 'company-select-next)

;;   ;; Use Shift-TAB to select previous candidate
;;   (define-key company-active-map (kbd "<backtab") 'company-select-previous)

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

;; Manually trigger completion
(global-set-key (kbd "M-/") 'company-complete)

;; Quickly open config
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
 '(package-vc-selected-packages
   '((vc-use-package :vc-backend Git :url "https://github.com/slotThe/vc-use-package"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
