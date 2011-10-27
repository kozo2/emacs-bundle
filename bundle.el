;;; bundle.el --- Emacs version of vundle.vim

(require 'cl)

(defvar bundle-install-directory "~/.emacs.d/bundle")

(unless (file-exists-p (concat bundle-install-directory "/" "init-bundle.el"))
  (shell-command (concat "touch " (concat bundle-install-directory "/" "init-bundle.el"))))

(defvar bundle-install-last-url nil
  "The last url used in `bundle-install-from-url'.")

(defun bundle-install-from-github (&optional url)
  "Install elisp files from a given url."
  (interactive)
  (or url (setq url (read-string (format "URL (%s):" (or bundle-install-last-url "")) nil nil bundle-install-last-url)))
  (setq bundle-install-last-url url)
  (message (format "cloning...: %s" bundle-install-last-url))
  (setq bundle-install-path (format (concat bundle-install-directory "/" (file-name-sans-extension (file-name-nondirectory bundle-install-last-url)))))
  (setq bundle-github-command (format (concat "git clone " bundle-install-last-url " " bundle-install-path)))
  (setq bundle-init-path (format (concat bundle-install-directory "/" "init-bundle.el")))
  (shell-command bundle-github-command)
  (add-to-list 'load-path bundle-install-path)
  (append-to-file (concat "(add-to-list 'load-path \"" bundle-install-path "\")") nil bundle-init-path)
)
