;;; bundle.el --- Emacs version of vundle.vim
;; bundle.el is distributed under the term of GPLv3.

(require 'cl)
(require 'deferred)

(defvar bundle-install-directory (expand-file-name "~/.emacs.d/bundle"))
(defvar bundle-init-filename "init-bundle.el")
(defvar bundle-init-filepath (concat bundle-install-directory "/" bundle-init-filename))

(unless (file-exists-p bundle-install-directory)
  (shell-command (concat "mkdir " bundle-install-directory)))
(unless (file-exists-p bundle-init-filepath)
  (shell-command (concat "touch " bundle-init-filepath)))
(load bundle-init-filepath)

(defvar bundle-install-last-url nil
  "The last url used in `bundle-install-from-url'.")

(defun bundle-install-git (&optional url)
  "Install elisp files from a given url using git."
  (interactive)
  (or url (setq url (read-string (format "URL (%s):" (or bundle-install-last-url "")) nil nil bundle-install-last-url)))
  (setq bundle-install-last-url url)

  (lexical-let* ((dirname (file-name-sans-extension (file-name-nondirectory bundle-install-last-url)))
                 (install-path (concat bundle-install-directory "/" dirname))
                 (copyed-url url))
      (deferred:$
        (deferred:process "git" "clone" bundle-install-last-url install-path)
        (deferred:nextc it
          (lambda ()
            (message (format "cloning...: %s" (concat "git clone " bundle-install-last-url " " install-path)))
            (add-to-list 'load-path install-path)
            (append-to-file (concat "(add-to-list 'load-path \"" install-path "\")\n") nil bundle-init-filepath)
            (load (concat bundle-install-directory "/" "init-bundle.el"))))

        (deferred:error it ;
          (lambda (err)
            (insert "Can not get a clone! : " err))))))
