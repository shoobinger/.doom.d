;;; readlist.el --- Custom functions to manage the Readlist Org file.
;;; Commentary:
;;;
;;; Code:

(define-minor-mode readlist-mode
  " Toggle Readlist mode"
  :init-value nil
  :lighter " Readlist"
  :keymap (make-sparse-keymap))

(defun readlist-start-reading()
  "Move the selected book to the ACTIVE status and create a notes org file for it."
  (interactive)
  (org-todo "ACTIVE")
  (let ((element (org-element-at-point))
        (current-project (projectile-project-root)))
    (let ((book-name (org-element-property :raw-value element)))
      (let ((new-file (concat current-project "notes/books/" book-name ".org")))
        ;; Create a new notes file.
        (shell-command (concat "touch '" new-file "'"))

        ;; Put the newly created file to the project cache.
        (unless (projectile-file-cached-p new-file current-project)
          (puthash current-project
                   (cons new-file (gethash current-project projectile-projects-cache))
                   projectile-projects-cache)
          (projectile-serialize-cache))

        ;; Replace the heading with the link to the file.
        (org-edit-headline (concat "[[file:" new-file "][" book-name "]]"))
  ))))

(provide 'readlist)

;;; readlist.el ends here
