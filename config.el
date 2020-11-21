;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(add-to-list 'load-path "~/.doom.d/lib")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")


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
;;
;; Treemacs.
(setq doom-themes-treemacs-enable-variable-pitch nil)

;; Readlist.
(require 'readlist)
(map! :map readlist-mode-map :desc "Start reading selected book" :localleader "u" #'readlist-start-reading)

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

;; Mail.

(require 'mu4e)
;;(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-root-maildir "~/mail")
;;(setq mu4e-maildir "~/mail")

;; don't save message to Sent Messages, GMail/IMAP will take care of this
(setq mu4e-sent-messages-behavior 'delete)

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "mbsync -c ~/.config/isync/config personal"
      mu4e-update-interval 60)

(setq mu4e-contexts
      `( ,(make-mu4e-context
           :name "Personal"
           :match-func (lambda (msg)
                         (when msg
                           (string-match-p "^/personal" (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address . "is@suive.co" )
                    ( user-full-name . "Ivan Suvorov" )
                    ( mu4e-drafts-folder . "/personal/Drafts" )
                    ( mu4e-sent-folder  .  "/personal/Sent" )
                    ( mu4e-trash-folder . "/personal/Trash" )
                    ))
      ,(make-mu4e-context
           :name "Arrival"
           :match-func (lambda (msg)
                         (when msg
                           (string-match-p "^/arrival" (mu4e-message-field msg :maildir))))
           :vars '( ( user-mail-address . "suvorov@arrival.com"  )
                    ( user-full-name . "Ivan Suvorov" )
                    ( mu4e-drafts-folder . "/arrival/[Gmail]/Drafts" )
                    ( mu4e-sent-folder .  "/arrival/[Gmail]/Sent Mail" )
                    ( mu4e-trash-folder . "/arrival/[Gmail]/Bin" )
                    ))))

(setq mu4e-headers-auto-update t)
(setq mu4e-headers-show-threads nil)
(setq mu4e-split-view 'vertical)

;;(set-face-attribute 'mu4e-view-body-face nil :font "Charis SIL" :height 150)
;;(set-face-attribute 'mu4e-header-face nil :font "Inter" :height 150)
