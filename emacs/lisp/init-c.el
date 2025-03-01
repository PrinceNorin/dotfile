;;; init-c.el --- C/C++ configuration settings -*- lexical-binding: t -*-
;;; Comentart:
;;; Code:

(setq-default
 c-default-style "linux"
 c-basic-offset 4
 c-ts-mode-indent-offset 4
 indent-tabs-mode nil
 tab-width 4
 indent-line-function 'insert-tab)

(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c-ts-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)
(add-hook 'c++-ts-mode-hook #'lsp-deferred)


(provide 'init-c)

;;; init-c.el ends here
