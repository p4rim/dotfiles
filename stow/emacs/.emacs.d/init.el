;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-pinned-packages '(evil . "melpa"))
(package-initialize)

;; Use current Evil for compatibility with Emacs 31.
(unless (package-installed-p 'evil)
  (package-refresh-contents)
  (package-install 'evil))

;; Use Vim's undo/redo keys with Emacs's built-in undo history.
(setq evil-undo-system 'undo-redo)
(require 'evil)
(evil-mode 1)

;;; init.el ends here
