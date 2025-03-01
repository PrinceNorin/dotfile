;;; init-go.el --- Go configuration settings -*- lexical-binding: t -*-
;;; Comentart:
;;; Code:

(defun local/setup-go-settings ()
  (setq go-ts-mode-indent-tabs-mode t)
  (setq go-ts-mode-indent-offset 4)
  (add-hook 'go-ts-mode-hook #'lsp-deferred))

(when (executable-find "gopls")
  (add-hook 'prog-mode-hook #'local/setup-go-settings))

(provide 'init-go)

;;; init-c.el ends here
