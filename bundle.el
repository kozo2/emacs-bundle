;;; bundle.el --- Emacs version of vundle.vim
;; bundle.el is distributed under the term of GPLv3.

(require 'cl)

(defvar bundle-install-directory (expand-file-name "~/.emacs.d/bundle"))
(defvar bundle-init-filename "init-bundle.el")
(defvar bundle-init-filepath (concat bundle-install-directory "/" bundle-init-filename))

(unless (file-exists-p bundle-install-directory)
  (shell-command (concat "mkdir " bundle-install-directory)))
(unless (file-exists-p bundle-init-filepath)
  (shell-command (concat "touch " bundle-init-filepath)))
(load bundle-init-filepath)

;(require 'deferred)

(defvar bundle-install-last-url nil
  "The last url used in `bundle-install-from-url'.")

(defun bundle-install-git (&optional url)
  "Install elisp files from a given url using git."
  (interactive)
  (or url (setq url (read-string (format "URL (%s):" (or bundle-install-last-url "")) nil nil bundle-install-last-url)))
  (setq bundle-install-last-url url)

  (setq bundle-install-path (format (concat bundle-install-directory "/" (file-name-sans-extension (file-name-nondirectory bundle-install-last-url)))))

  (deferred:$
;    (deferred:process-shell ("git" "clone" bundle-git-clone))
    (deferred:process "git" "clone" bundle-install-last-url bundle-install-path)
;    (deferred:process ("ls"))
;  (setq bundle-git-clone (format (concat "git clone " bundle-install-last-url " " bundle-install-path)))
    (deferred:nextc it
      (lambda ()
;	(message (format "cloning...: %s" bundle-install-last-url))
	(message (format "cloning...: %s" (concat "git clone " bundle-install-last-url " " bundle-install-path)))
;    (deferred:nextc it
	(add-to-list 'load-path bundle-install-path)
;    (deferred:nextc it
	(append-to-file (concat "(add-to-list 'load-path \"" bundle-install-path "\")\n") nil bundle-init-path)
;    (deferred:nextc it
	(load (concat bundle-install-directory "/" "init-bundle.el"))))
    
    (deferred:error it ;
      (lambda (err)
	(insert "Can not get a clone! : " err))))

;  (setq bundle-init-path (format (concat bundle-install-directory "/" "init-bundle.el")))
;  (shell-command bundle-git-clone)
)

;; (defun bundle-install-svn (&optional url)
;;   "Install elisp files from a given url using svn."
;;   (interactive)
;;   (or url (setq url (read-string (format "URL (%s):" (or bundle-install-last-url "")) nil nil bundle-install-last-url)))
;;   (setq bundle-install-last-url url)
;;   (message (format "cloning...: %s" bundle-install-last-url))
;;   (setq bundle-install-path (format (concat bundle-install-directory "/" (file-name-sans-extension (file-name-nondirectory bundle-install-last-url)))))
;;   (setq bundle-svn-checkout (format (concat "svn checkout " bundle-install-last-url " " bundle-install-path)))
;;   (setq bundle-init-path (format (concat bundle-install-directory "/" "init-bundle.el")))
;;   (shell-command bundle-svn-checkout)
;;   (add-to-list 'load-path bundle-install-path)
;;   (append-to-file (concat "(add-to-list 'load-path \"" bundle-install-path "\")") nil bundle-init-path)
;; )

;; (defun bundle-install-emacs-w3m ()
;;   "Install emacs-w3m from cvs repository."
;;   (interactive)
;;   (setq bundle-init-path (format (concat bundle-install-directory "/" "init-bundle.el")))
;;   (shell-command "cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m")
;;   (add-to-list 'load-path (concat bundle-install-directory "/" "emacs-w3m"))
;;   (append-to-file (concat "(add-to-list 'load-path \"" (concat bundle-install-directory "/" "emacs-w3m" "\")") nil bundle-init-path))
;; )
