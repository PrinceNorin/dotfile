;;
;; Package management
;;
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Common variables
(defvar user-init-dir
  (file-name-as-directory
   (file-name-directory user-emacs-directory)))

;; Custom theme path
(defvar custom-theme-dir (concat user-init-dir "themes"))
(add-to-list 'custom-theme-load-path custom-theme-dir)
(load-theme 'dracula t)

;; Default settings
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq make-backup-files nil)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

(setq byte-compile-warnings '(not docstrings))

;; Dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; Bring vim to emacs
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode t))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package general
  :ensure t)

(use-package evil-nerd-commenter
  :ensure t)
(with-eval-after-load 'evil-nerd-commenter
  (define-key evil-normal-state-map (kbd "gc") 'evilnc-comment-or-uncomment-lines))

;; Smart parentheses
(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t))

;; Autocomplete
(use-package company
  :ensure t
  :config
  (global-company-mode t))

(with-eval-after-load 'company
  (define-key company-active-map
    (kbd "TAB") #'company-complete-common-or-cycle)
  (define-key company-active-map
    (kbd "<backtab>") (lambda ()
                        (interactive)
                        (company-complete-common-or-cycle -1))))

;; Show list of commands
(use-package vertico
  :ensure t
  :config
  (vertico-mode t))

;; Orderless
(use-package orderless
  :ensure t
  :init (icomplete-mode)
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Which key
(use-package which-key
  :ensure t
  :config
  (which-key-mode t))

;; Mode line
(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode t))

;; Go
(use-package go-mode
  :ensure t
  :init
  (setq gofmt-command "goimports")
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-to-list 'auto-mode-alist '("\\.go$" . go-mode))
  (add-hook 'go-mode-hook (lambda ()
                            (setq tab-width 4)
                            (setq indent-tabs-mode t))))

;; Python
(use-package python-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
  (add-hook 'python-mode-hook (lambda () (setq tab-width 4))))

;; C/C++
(add-hook 'c-mode-hook (lambda () (setq tab-width 4)))
(add-hook 'c++-mode-hook (lambda () (setq tab-width 4)))

;; Fuzzy find
(defcustom project-root-markers
  '("Cargo.toml" "compile_commands.json" "compile_flags.txt"
    "project.clj" ".git" "deps.edn" "shadow-cljs.edn")
  "Files or directories that indicate the root of a project."
  :type '(repeat string)
  :group 'project)

(defun project-root-p (path)
  "Check if the current PATH has any of the project root markers."
  (catch 'found
    (dolist (marker project-root-markers)
      (when (file-exists-p (concat path marker))
        (throw 'found marker)))))

(defun project-find-root (path)
  "Search up the PATH for `project-root-markers'."
  (when-let ((root (locate-dominating-file path #'project-root-p)))
    (cons 'transient (expand-file-name root))))

(add-to-list 'project-find-functions #'project-find-root)
(define-key evil-normal-state-map (kbd "C-p") 'project-find-file)

;; Do not edit these lines
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(vertico company evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
