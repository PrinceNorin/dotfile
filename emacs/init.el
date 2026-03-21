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
(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)


;; ====================
;; Installed packages
;; ====================

;; Load Shell Variables
(use-package exec-path-from-shell
  :straight t
  :init
  (when (display-graphic-p)
    (exec-path-from-shell-initialize)))


;; Better GUI Font
(defun saint/default-font-setup ()
  (let ((font-name "FiraCode Nerd Font-9"))
    (add-to-list 'default-frame-alist `(font . ,font-name))
    (set-face-attribute 'default nil :font font-name)))

(use-package unicode-fonts
  :straight t
  :init
  (unicode-fonts-setup))

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
   (prog-mode . display-line-numbers-mode)
   (prog-mode . hl-line-mode)))

;; Better completion
(use-package vertico
  :straight t
  :init
  (vertico-mode +1))

(use-package orderless
  :straight t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode))

(use-package consult
  :straight t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)))

;; Which-key
(use-package which-key
  :straight t
  :init
  (which-key-mode))

;; Better modeline
(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-bar-width 3
        doom-modeline-buffer-encoding t
        doom-modeline-indent-info t
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-lsp t
        doom-modeline-checker-simple-format t
        doom-modeline-vcs-max-length 50
        doom-modeline-enable-vcs t
        doom-modeline-vcs t))

;; Modern theme
(use-package doom-themes
  :straight t
  :init
  (load-theme 'doom-solarized-light t))

;; Adjusting for macOS
(when (eq system-type 'darwin)
  (when (< emacs-major-version 29)
    (use-package osx-trash
      :straight t))

  (use-package ns-auto-titlebar
    :straight t)

  (setq locate-command "mdfind")
  (setq ns-pop-up-frames nil)
  (setq mac-redisplay-dont-reset-vscroll t
        mac-mouse-wheel-smooth-scroll nil)

  (and (or (daemonp)
           (display-graphic-p))
       (require 'ns-auto-titlebar nil t)
       (ns-auto-titlebar-mode +1))

  (setq delete-by-moving-to-trash (not noninteractive)))


;; ====================
;; Editing enhancements
;; ====================

(use-package undo-fu
  :straight t
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(use-package expand-region
  :straight t
  :bind ("C-=" . er/expand-region))


;; ====================
;; Essential utilities
;; ====================

;; Project management
(use-package project
  :straight t
  :bind (("C-x p" . project-switch-project))
  :config
  (add-to-list 'project-vc-extra-root-markers ".git")
  (add-to-list 'project-vc-extra-root-markers "pom.xml")
  (add-to-list 'project-vc-extra-root-markers "build.gradle"))

;; Projectile
(use-package projectile
  :straight t
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
  :straight t
  :bind ("C-x g" . magit-status))

(use-package git-gutter
  :straight t
  :config
  (global-git-gutter-mode +1))

;; Terminal in Emacs
(use-package vterm
  :straight t
  :commands vterm)

;; Better window management
(use-package winner
  :straight t
  :init
  (winner-mode))


;; ====================
;; Programming setup
;; ====================

;; Delete up to to next tabstop
(use-package hungry-delete
  :straight t
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
  :straight t
  :after yaml-mode
  :hook ((yaml-mode . yaml-pro-mode)
         (yaml-ts-mode . yaml-pro-mode))
  :config
  (setq yaml-pro-indent 2)
  (setq yaml-ts-indent-offset 2))

;; Configure Erlang
(use-package erlang-ts
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
  :mode (("\\.ex\\'" . elixir-ts-mode)
         ("\\.exs\\'" . elixir-ts-mode)
         ("mix\\.lock" . elixir-ts-mode)))

;; Configure Kotlin
(use-package kotlin-ts-mode
  :mode ("\\.kt\\'" "\\.kts\\'")
  :config
  (setq kotlin-tab-width 4)
  (setq indent-tabs-mode nil))

;; Treesitter
(use-package treesit-auto
  :straight t
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

;; Configure LSP Mode
(use-package lsp-mode
  :straight t
  :hook
  ((python-ts-mode . lsp)
   (js-ts-mode . lsp)
   (typescript-ts-mode . lsp)
   (go-ts-mode . lsp)
   (c-mode . lsp)
   (c++-mode . lsp)
   (java-ts-mode . lsp)
   (kotlin-ts-mode . lsp)
   (lua-mode . lsp)
   (ruby-mode . lsp)
   (php-mode . lsp))
  :config
  (setq lsp-completion-provider :none))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-peek-enable t
        lsp-ui-peek-always-show t
        lsp-ui-doc-enable t
        lsp-ui-doc-position 'top
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-border (face-foreground 'default)
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-imenu-enable t
        lsp-ui-flycheck-enable t))

;; Format on save
(use-package apheleia
  :straight t
  :config
  (apheleia-global-mode +1)
  (setf (alist-get 'go-ts-mode apheleia-mode-alist)
        '(goimports)))

;; Configure Go
(use-package go-ts-mode
  :mode (("\\.go\\'" . go-ts-mode)
         ("go.mod" . gomod-ts-mode)
         ("go.sum" . gomod-ts-mode))
  :hook (go-ts-mode . (lambda ()
                        (setq tab-width 4)
                        (setq indent-tabs-mode t)
                        (setq go-ts-mode-indent-offset 4))))

;; Configure completion
(use-package nerd-icons
  :straight t
  :commands (nerd-icons-octicon
             nerd-icons-faicon
             nerd-icons-flicon
             nerd-icons-wicon
             nerd-icons-mdicon
             nerd-icons-codicon
             nerd-icons-devicon
             nerd-icons-ipsicon
             nerd-icons-pomicon
             nerd-icons-powerline))

(use-package company
  :straight t
  :commands (company-complete-common
             company-complete-common-or-cycle
             company-manual-begin
             company-grab-line)
  :init
  (setq company-minimum-prefix-length 2
        company-tooltip-limit 14
        company-tooltip-align-annotations t
        company-require-match 'never
        company-idle-delay
        (if (featurep :system 'macos)
            0.4
          0.26)
        company-global-modes
        '(not erc-mode
              circe-mode
              message-mode
              help-mode
              gud-mode
              vterm-mode)
        company-frontends
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)
        company-backends '(company-capf)
        company-auto-commit t
        company-dabbrev-other-buffers nil
        company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil)
  (global-company-mode))

(use-package company-box
  :straight t
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-show-single-candidate t
        company-box-backends-colors nil
        company-box-tooltip-limit 50
        company-box-icons-alist 'company-box-icons-nerd-icons
        company-box-icons-nerd-icons
        `((Unknown        . ,(nerd-icons-codicon  "nf-cod-code"                :face  'font-lock-warning-face))
          (Text           . ,(nerd-icons-codicon  "nf-cod-text_size"           :face  'font-lock-doc-face))
          (Method         . ,(nerd-icons-codicon  "nf-cod-symbol_method"       :face  'font-lock-function-name-face))
          (Function       . ,(nerd-icons-codicon  "nf-cod-symbol_method"       :face  'font-lock-function-name-face))
          (Constructor    . ,(nerd-icons-codicon  "nf-cod-triangle_right"      :face  'font-lock-function-name-face))
          (Field          . ,(nerd-icons-codicon  "nf-cod-symbol_field"        :face  'font-lock-variable-name-face))
          (Variable       . ,(nerd-icons-codicon  "nf-cod-symbol_variable"     :face  'font-lock-variable-name-face))
          (Class          . ,(nerd-icons-codicon  "nf-cod-symbol_class"        :face  'font-lock-type-face))
          (Interface      . ,(nerd-icons-codicon  "nf-cod-symbol_interface"    :face  'font-lock-type-face))
          (Module         . ,(nerd-icons-codicon  "nf-cod-file_submodule"      :face  'font-lock-preprocessor-face))
          (Property       . ,(nerd-icons-codicon  "nf-cod-symbol_property"     :face  'font-lock-variable-name-face))
          (Unit           . ,(nerd-icons-codicon  "nf-cod-symbol_ruler"        :face  'font-lock-constant-face))
          (Value          . ,(nerd-icons-codicon  "nf-cod-symbol_field"        :face  'font-lock-builtin-face))
          (Enum           . ,(nerd-icons-codicon  "nf-cod-symbol_enum"         :face  'font-lock-builtin-face))
          (Keyword        . ,(nerd-icons-codicon  "nf-cod-symbol_keyword"      :face  'font-lock-keyword-face))
          (Snippet        . ,(nerd-icons-codicon  "nf-cod-symbol_snippet"      :face  'font-lock-string-face))
          (Color          . ,(nerd-icons-codicon  "nf-cod-symbol_color"        :face  'success))
          (File           . ,(nerd-icons-codicon  "nf-cod-symbol_file"         :face  'font-lock-string-face))
          (Reference      . ,(nerd-icons-codicon  "nf-cod-references"          :face  'font-lock-variable-name-face))
          (Folder         . ,(nerd-icons-codicon  "nf-cod-folder"              :face  'font-lock-variable-name-face))
          (EnumMember     . ,(nerd-icons-codicon  "nf-cod-symbol_enum_member"  :face  'font-lock-builtin-face))
          (Constant       . ,(nerd-icons-codicon  "nf-cod-symbol_constant"     :face  'font-lock-constant-face))
          (Struct         . ,(nerd-icons-codicon  "nf-cod-symbol_structure"    :face  'font-lock-variable-name-face))
          (Event          . ,(nerd-icons-codicon  "nf-cod-symbol_event"        :face  'font-lock-warning-face))
          (Operator       . ,(nerd-icons-codicon  "nf-cod-symbol_operator"     :face  'font-lock-comment-delimiter-face))
          (TypeParameter  . ,(nerd-icons-codicon  "nf-cod-list_unordered"      :face  'font-lock-type-face))
          (Template       . ,(nerd-icons-codicon  "nf-cod-symbol_snippet"      :face  'font-lock-string-face))
          (ElispFunction  . ,(nerd-icons-codicon  "nf-cod-symbol_method"       :face  'font-lock-function-name-face))
          (ElispVariable  . ,(nerd-icons-codicon  "nf-cod-symbol_variable"     :face  'font-lock-variable-name-face))
          (ElispFeature   . ,(nerd-icons-codicon  "nf-cod-globe"               :face  'font-lock-builtin-face))
          (ElispFace      . ,(nerd-icons-codicon  "nf-cod-symbol_color"        :face  'success))))
  (setq x-gtk-resize-child-frames 'resize-mode)
  (add-to-list 'company-box-frame-parameters '(tab-bar-lines . 0)))

;; (defun corfu-complete-or-newline ()
;;   "If a candiate is selected, complete it. Otherwise insert a newline"
;;   (interactive)
;;   (if (and (bound-and-true-p corfu-mode)
;;            corfu--candidates
;;            corfu--index
;;            (>= corfu--index 0))
;;       (corfu-complete)
;;     (newline)))

;; (use-package corfu
;;   :ensure t
;;   :custom
;;   (corfu-auto t)
;;   (corfu-preselect 'prompt)
;;   (corfu-auto-delay 0.2)
;;   (corfu-auto-prefix 1)
;;   (corfu-cycle t)
;;   (corfu-quit-at-boundary t)
;;   (corfu-quit-no-match t)
;;   (corfu-no-exact-match nil)

;;   :bind
;;   (:map corfu-map
;;         ("C-p" . nil)
;;         ("C-n" . nil)
;;         ("TAB" . corfu-next)
;;         ("S-TAB" . corfu-previous)
;;         ("RET" . corfu-complete-or-newline))

;;   :init
;;   (global-corfu-mode))

;; Configure AI code completion
(use-package dash
  :straight t)

(use-package plz
  :straight t
  :config
  (setq plz-connect-timeout 10)
  (setq plz-read-timeout 30))

(use-package minuet
  :straight t
  :after company
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


;; =====================
;; Keybindings
;; =====================

;; Easier window navigation
(global-set-key (kbd "M-o") 'other-window)

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
