;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(add-to-list 'load-path "~/.doom.d/lib")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ivan Suvorov"
      user-mail-address "is@suive.co")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Charis SIL" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; Enable pass integration.
;; Treemacs.
(setq doom-themes-treemacs-enable-variable-pitch nil)

;; Enable auto-formatting
(defvar my-auto-format-modes '(elisp-mode))

(defun my-auto-format-buffer-p ()
  (and (member major-mode my-auto-format-modes)
       (buffer-file-name)
       my-auto-format-dirs))

(defun my-after-change-major-mode ()
  (format-all-mode (if (my-auto-format-buffer-p) 1 0)))

(add-hook 'after-change-major-mode-hook 'my-after-change-major-mode)

;; Readlist.
(require 'readlist)
(map! :map readlist-mode-map :desc "Start reading selected book" :localleader "u" #'readlist-start-reading)

;; Company (autocomplete)
;; Company is enabled globally, disable it for some major modes.
(setq company-global-modes '(not org-mode erc-mode message-mode help-mode gud-mode)
      company-minimum-prefix-length 1
      company-idle-delay 0.1)

;; LSP
(setq lsp-idle-delay 0.1
      lsp-headerline-breadcrumb-enable t)

;; DAP
(require 'dap-gdb-lldb)

;; Org mode.
(require 'org-variable-pitch)
(add-hook 'org-mode-hook
          '(lambda () (progn
                        (set-face-attribute 'org-variable-pitch-fixed-face nil
                                            :family (org-variable-pitch--get-fixed-font))
                        (org-variable-pitch--enable)
                        (doom-disable-line-numbers-h)
                        (setq left-margin-width 1)
                        (setq right-margin-width 1))))


(setq deft-directory "~/org")

;; Mail.
(defun notmuch-buffer-p (buffer)
  (string-match-p "^\\*notmuch-" (buffer-name buffer)))
(push #'notmuch-buffer-p doom-real-buffer-functions)

(setq sendmail-program "/usr/bin/msmtp"
      mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header
      send-mail-function 'message-send-mail-with-sendmail
      message-directory "~/mail/"
      notmuch-maildir-use-notmuch-insert 't
      message-fcc-handler-function 'message-do-fcc
      notmuch-fcc-dirs '(("is@suive.co" . "personal/Sent/ -inbox +sent -unread")))

(setq notmuch-saved-searches
      '((:name "inbox: all" :query "tag:inbox not tag:trash" :key "i")
        (:name "inbox: personal" :query "tag:personal and tag:inbox not tag:trash")
        (:name "sent: personal" :query "tag:personal and tag:sent")
        (:name "archive: personal" :query "tag:personal and not tag:inbox and not tag:spam and not tag:trash")
        (:name "inbox: work" :query "tag:work and tag:inbox not tag:trash")
        (:name "sent: work" :query "tag:work and tag:sent")
        (:name "archive: work" :query "tag: work and not tag:inbox and not tag:spam and not tag:trash")))

(with-eval-after-load 'message
  (setq message-cite-style message-cite-style-gmail)
  (setq message-citation-line-function 'message-insert-formatted-citation-line))

;; Elfeed
(setq-default elfeed-search-filter "@2-week-ago +unread ")
(map! :leader :desc "Open feeds" "o n" #'elfeed)
(setq elfeed-db-directory "~/.local/share/elfeed")
(require 'feeds "~/.local/share/feeds.el")
(setq elfeed-feeds feeds)

(map! :map elfeed-search-mode-map
      :after elfeed-search
      [remap kill-this-buffer] "q"
      [remap kill-buffer] "q"
      :n doom-leader-key nil
      :n "q" #'+rss/quit
      :n "e" #'elfeed-update
      :n "RET" #'elfeed-search-show-entry
      :n "p" #'elfeed-show-pdf
      :n "+" #'elfeed-search-tag-all
      :n "-" #'elfeed-search-untag-all
      :n "S" #'elfeed-search-set-filter
      :n "b" #'elfeed-search-browse-url
      :n "y" #'elfeed-search-yank)
(map! :map elfeed-show-mode-map
      :after elfeed-show
      [remap kill-this-buffer] "q"
      [remap kill-buffer] "q"
      :n doom-leader-key nil
      :nm "q" #'+rss/delete-pane
      :nm "o" #'ace-link-elfeed
      :nm "RET" #'org-ref-elfeed-add
      :nm "J" #'elfeed-show-next
      :nm "K" #'elfeed-show-prev
      :nm "p" #'elfeed-show-pdf
      :nm "b" #'elfeed-show-visit
      :nm "+" #'elfeed-show-tag
      :nm "-" #'elfeed-show-untag
      :nm "s" #'elfeed-show-new-live-search
      :nm "y" #'elfeed-show-yank)

;; Set update timer (15m).
(run-at-time nil (* 15 60) #'elfeed-update)

;; Open YouTube links in mpv.
(defun browse-url-mpv (url &optional new-window)
  (start-process "mpv" "*mpv*" "mpv" url))

(setq browse-url-handlers '(("https:\\/\\/www\\.youtube." . browse-url-mpv)
                                    ("." . browse-url-xdg-open)))

;; Enable Russian-to-English layout translation in commands.
(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))

;; Dired
;; Open with xdg-open.
(defun dired-open-file()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "xdg-open" nil 0 nil file)
    (message "Opening %s done" file)))

(map! :map dired-mode-map "o" #'dired-open-file)

;; Org-agenda
(setq org-agenda-files '("~/org/events.org"))
