;;; init-lsp.el --- Language server settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)
(require-package 'lsp-ui)

(add-hook 'prog-mode-hook 'lsp-deferred)

(setq lsp-keymap-prefix "C-c l")
(setq lsp-completion-provider :none)
(setq lsp-completion-show-detail nil)
(setq lsp-signature-render-documentation nil)

;; disabled unspport client warning
(setq lsp-warn-no-matched-clients nil)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(provide 'init-lsp)

;;; init-lsp.el ends here
