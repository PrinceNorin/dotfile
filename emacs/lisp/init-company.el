;;; init-company.el --- Company mode settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'company)
(require-package 'company-box)

(add-hook 'lsp-mode-hook 'company-mode)
(add-hook 'company-mode-hook 'company-box-mode)

(setq company-tooltip-align-annotations t)
(setq company-tooltip-limit 5)

(custom-set-faces
 '(company-tooltip ((t (:background "#073642" :foreground "#839496"))))
 '(company-tooltip-selection ((t (:background "#586e75" :foreground "#93a1a1"))))
 '(company-tooltip-common ((t (:foreground "#b58900" :underline t))))
 '(company-tooltip-common-selection ((t (:foreground "#b58900" :underline t))))
 '(company-scrollbar-bg ((t (:background "#073642"))))
 '(company-scrollbar-fg ((t (:background "#586e75"))))
 '(company-preview ((t (:background "#073642" :foreground "#839496"))))
 '(company-preview-common ((t (:foreground "#b58900" :underline t)))))

(provide 'init-company)

;;; init-company.el ends here
