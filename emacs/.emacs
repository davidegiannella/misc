;;shell vs gui paths
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

;;adding local directory for modes loading
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;;enable syntax highlight by default
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size nil)

;;disable line wrapping
(setq-default truncate-lines t)

;;always show the column number
(setq-default column-number-mode t)

;;disable autosave and backup
(setq auto-save-default nil)
(setq make-backup-files nil)

;; Force to use spaces for tabs and to be 3 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

;;default attributes for text-mode
(setq text-mode-hook '(lambda()
(auto-fill-mode t) ;;physical line break
(flyspell-mode t) ;;spellchek on the fly
(ispell-change-dictionary "english" nil)
)
)

;;default attributes for mail-mode
(setq mail-mode-hook '(lambda()
(auto-fill-mode t) ;;physical line break
(flyspell-mode t) ;;spellchek on the fly
;;(ispell-change-dictionary "italiano" nil)
)
)

;;sets the file name as window title (for graphics emacs)
(set 'frame-title-format '(myltiple-frames "%b" ("" "%b")))

;;log4j mode
(require 'jtags)
(autoload 'log4j-mode "log4j-mode" "Major mode for viewing log files." t)
(add-to-list 'auto-mode-alist '("\\.log\\'" . log4j-mode))

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;custom markdown-mode settings
(setq markdown-mode-hook '(lambda()
                            (auto-fill-mode t) 
                            (flyspell-mode t) ;;spellchek on the fly
                            (ispell-change-dictionary "english" nil)
                            )
      )

;; ;;Move emacs a bit down and on the right in order to avoid a possible ugly
;; ;;windows bug. If you like to have the taskbar on top of the screen, sometimes
;; ;;emacs starts with the title bar under it.
;; ;;(setq initial-frame-alist '((left . 50) (top . 50)))

;; ;; ;;php-mode.el
;; ;; (require 'php-mode)
;; ;; ;;html-helper-mode
;; ;; (autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;; ;; (setq auto-mode-alist (cons '("\\.jsp$" . html-helper-mode) auto-mode-alist)) ;;hhm for jsp files
;; ;; (setq html-helper-never-indent t)
;; ;; ;;disable auto-fill-mode and fly-spell-mode for hhm
;; ;; (setq html-helper-mode-hook '(lambda()
;; ;; (auto-fill-mode nil)
;; ;; (flyspell-mode nil)
;; ;; (local-set-key "\t" 'self-insert-command)
;; ;; )
;; ;; )


;; ;; ;;python-mode
;; ;; (require 'python-mode)
;; ;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))

;; set alternative keys (math symbols etc)
(define-key key-translation-map (kbd "M-V") (kbd "√"))

;; docker-mode
;; https://github.com/spotify/dockerfile-mode
(add-to-list 'load-path "dockerfile-mode")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
