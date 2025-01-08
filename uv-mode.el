;;; uv-mode.el --- Integrate uv with python-mode -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 z80
;;
;; Author: z80 <z80@ophy.xyz>
;; Maintainer: z80 <z80@ophy.xyz>
;; Created: December 13, 2024
;; Modified: December 13, 2024
;; Version: 0.0.1
;; Homepage: https://github.com/z80dev/uv-mode
;; Package-Requires: ((emacs "25.1") (pythonic "0.1.0"))
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; UV mode provides integration between uv (the Python package installer)
;; and Emacs python-mode.  Unlike pyenv which manages multiple Python versions,
;; this mode focuses on managing project-specific virtual environments created by uv.

;;; Code:

(require 'pythonic)

(defgroup uv nil
  "UV virtualenv integration with python mode."
  :group 'languages)

(defcustom uv-mode-mode-line-format
  '(:eval
    (when (uv-mode-version)
      (concat "UV:" (uv-mode-version) " ")))
  "How `uv-mode' will indicate the current virtual environment in the mode line."
  :type 'string
  :group 'uv)

(defun uv-mode-version ()
  "Return currently active virtual environment name.
This looks for a .venv directory in the project root."
  (let ((project-root (locate-dominating-file default-directory ".venv")))
    (when project-root
      (file-name-nondirectory (directory-file-name project-root)))))

(defun uv-mode-root ()
  "Return the root directory of the current project with a .venv."
  (locate-dominating-file default-directory ".venv"))

(defun uv-mode-full-path (project-dir)
  "Return full path for virtualenv in PROJECT-DIR."
  (when project-dir
    (expand-file-name ".venv" project-dir)))

;;;###autoload
(defun uv-mode-set ()
  "Set python shell virtualenv for PROJECT."
  (interactive)
  (let ((venv-path (uv-mode-full-path (uv-mode-root))))
    (when venv-path
      (pythonic-activate venv-path)
      (setenv "VIRTUAL_ENV" venv-path)
      (force-mode-line-update))))

;;;###autoload
(defun uv-mode-unset ()
  "Unset python shell virtualenv."
  (interactive)
  (pythonic-deactivate)
  (setenv "VIRTUAL_ENV")
  (force-mode-line-update))

(defvar uv-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-s") 'uv-mode-set)
    (define-key map (kbd "C-c C-u") 'uv-mode-unset)
    map)
  "Keymap for `uv-mode'.")

;;;###autoload
(define-minor-mode uv-mode
  "Minor mode for uv virtualenv interaction.
\\{uv-mode-map}"
  :global t
  :lighter ""
  :keymap uv-mode-map
  (if uv-mode
      (if (executable-find "uv")
          (add-to-list 'mode-line-misc-info uv-mode-mode-line-format)
        (error "Uv-mode: uv executable not found"))
    (setq mode-line-misc-info
          (delete uv-mode-mode-line-format mode-line-misc-info))))

;;;###autoload
(defun uv-mode-auto-activate-hook ()
  "Automatically activate UV mode and the project's virtualenv if available.
This function checks for a .venv directory in the project root. If found,
it activates that virtualenv for the current buffer. This is especially
useful when automatically run via `python-mode-hook'."
  (when (derived-mode-p 'python-mode)
    (let ((project-root (uv-mode-root)))
      (when project-root
        (uv-mode 1)  ; Enable uv-mode
        (uv-mode-set)))))

(provide 'uv-mode)
;;; uv-mode.el ends here
