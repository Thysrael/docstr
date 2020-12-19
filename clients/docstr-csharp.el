;;; docstr-csharp.el --- Document string for C#  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Shen, Jen-Chieh <jcs090218@gmail.com>

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Document string for C#.
;;

;;; Code:

(require 'docstr)

;;;###autoload
(defun docstr-writers-csharp (search-string)
  "Insert document string for C# using SEARCH-STRING."
  (let* ((start (point)) (prefix "\n/// ")
         (paren-param-list (docstr-writers--paren-param-list search-string))
         (param-types (nth 0 paren-param-list))
         (param-vars (nth 1 paren-param-list))
         ;; Get the return data type.
         (return-type-str (docstr-writers--return-type search-string))
         docstring-type)
    ;; Determine the docstring type.
    (save-excursion
      (backward-char 1)
      (if (docstr-util-current-char-equal-p "*")
          (setq docstring-type 'javadoc) (setq docstring-type 'vsdoc)))

    (cl-case docstring-type
      (javadoc (docstr-writers-java search-string))
      (vsdoc
       (forward-line 1) (end-of-line)
       (let ((docstr-format-var "%s")
             (docstr-format-param "<param name=\"#V\"></param>")
             (docstr-format-return "<returns></returns>"))
         (docstr-writers--insert-param param-types param-vars prefix)
         (docstr-writers--insert-return return-type-str '("void") prefix))
       (docstr-writers-after start)))))

(provide 'docstr-csharp)
;;; docstr-csharp.el ends here
