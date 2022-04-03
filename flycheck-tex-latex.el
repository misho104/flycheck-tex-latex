;;; flycheck-tex-latex.el --- flycheck checker with latex compiler itself

;; Copyright (C) 2014 Misho

;; Author: Misho <contact@misho-web.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(provide 'flycheck-tex-latex)
(require 'flycheck)

(defun flycheck-get-latex-command ()
  (let ((cmd (YaTeX-get-builtin "!")))
      (cond
       ((null cmd) "pdflatex")
       ((eq cmd "") "pdflatex")
       (t cmd))))

(flycheck-define-command-checker 'tex-latex
    "A TeX and LaTeX syntax and style checker using latex."
      :command '("flycheck-latex" (eval (flycheck-get-latex-command)) source-inplace)
    :error-patterns
    '(
     (error line-start "! " (message "Undefined control sequence.\nl." line (one-or-more not-newline)) line-end)
     (error line-start "! " (message (one-or-more not-newline) "\n" (minimal-match (zero-or-more (zero-or-more not-newline) "\n")))
                      "l." line (zero-or-more not-newline) line-end)
     (warning  line-start "LaTeX Warning:" (message) " on input line " line "." line-end)
     )
    :modes '(tex-mode latex-mode plain-tex-mode yatex-mode))
(add-to-list 'flycheck-checkers 'tex-latex)
