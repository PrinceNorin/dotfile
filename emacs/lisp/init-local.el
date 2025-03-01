;;; init-local.el --- Custom local settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; custom font
(set-frame-font "Consolas 11" nil t)

;; remove ruler line
(setq-default display-fill-column-indicator-character "")

;; disable backup file
(setq make-backup-file nil)

(provide 'init-local)
;;; init-local.el ends here
