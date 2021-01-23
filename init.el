;; do not make audible ding, emacs will now flash the screen instead
(setq visible-bell 1)
;; do not flash the screen
(setq ring-bell-function 'ignore)

;; maxmise emacs frame on startup
(custom-set-variables
 '(initial-frame-alist '((fullscreen . maximized))))

;; do not show the startup screen
(setq inhibit-startup-message t)

(setq frame-title-format "emacs")

;; (defalias 'yes-or-no-p 'y-or-no-p)

;; disable tool bar, menu bar, scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; cursor: vertical bar
(setq-default cursor-type 'bar)

;; highlight current line
;; (global-hl-line-mode t)

;; display line numbers
(global-display-line-numbers-mode)
;; use relative line numbering
(setq display-line-numbers-type 'relative)
;; use column numbers instead of alphabets in mode line
(setq column-number-mode t)

;; set font face and size
(set-face-attribute 'default nil :font "Hasklug Nerd Font" :height 210)

;; delete trailing whitespaces before saving a file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; load `package`
(require 'package)

;; tells emacs not to load any packages before starting up
(setq package-enable-at-startup nil)

;; add `melpa`, `org`, `elpa` to `package-archives`
(setq package-archives '(("org"       . "https://orgmode.org/elpa/")
                         ("elpa"       . "https://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

;; initialize `package`
(package-initialize)

;; install `use-package` if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; load `use-package`
(require 'use-package)
;; "ensure" packages by default
(setq use-package-always-ensure t)

;; use theme
;; (load-theme 'tango-dark)
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

(use-package doom-modeline
  :disabled
  :hook
  (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 10))

(use-package command-log-mode
  :config
  (global-command-log-mode)
  (clm/toggle-command-log-buffer))

;; company uses backends to provide completions and a frontend to visualise the list of completions suggestions
(use-package company
  :config
  ;; Zero delay when pressing tab
  (setq company-idle-delay 0)
  (add-hook 'after-init-hook 'global-company-mode))
;; TODO: add company frontend such as https://github.com/company-mode/company-quickhelp ot company-box
;; company-box needs emacs 26
;; (use-package company-box
;;   :hook (company-mode . company-box-mode))

(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0))

(use-package ivy
  :config
  ;; add recent files and bookmarks to the ivy-switch-buffer
  (setq ivy-use-virtual-buffers t)
  ;; displays the current and total number in the collection in the prompt
  (setq ivy-count-format "%d/%d ")
  (ivy-mode 1))
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-switch-buffer)
         ("C-x C-f" . counsel-find-file))
  :config
  ;; Don't start searches with ^
  (setq ivy-initial-inputs-alist nil))
(use-package swiper
  :bind (("C-s" . swiper)))
(use-package ivy-rich
  :config
  (ivy-rich-mode 1))
(use-package prescient)
(use-package ivy-prescient
  :config
  (ivy-prescient-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package evil
  :config
  (evil-mode 1))
(use-package evil-collection
  :disabled
  :after evil
  :config
  (evil-collection-init))
;; TODO: use verticaal line as cursor for normal mode in evil-mode

(use-package undo-tree
    :defer 5
    :config
    (global-undo-tree-mode 1))

(use-package projectile
  :config
  (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/cventcode")
    (setq projectile-project-search-path '("~/cventcode")))
  (setq projectile-switch-project-action #'projectile-dired))
(use-package counsel-projectile
  :disabled
  :after projectile)

(use-package magit)
(use-package evil-magit
  :disabled
  :after magit)
(use-package forge
  :disabled)
(use-package magit-todos
  :disabled)

(defun org-mode-setup ()
  (org-indent-mode)
  ;; use visual-line-mode for soft-wrap instead of using auto-fill-mode for hard-wrap
  (auto-fill-mode 0)
  (visual-line-mode 1))
(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (setq org-capture-templates
	`(("f" "Fleeting Note" item (file+olp+datetree "~/Dropbox/Orgzly/fleeting.org")
           "%?" :prepend :kill-buffer)))
  (setq org-modules
	`(org-tempo))
  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

;; highlight matching parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)
(use-package paredit
  :config
  ;; use paredit with emacs' lisp modes
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode))
;; Ensure paredit is used EVERYWHERE!
(use-package paredit-everywhere
  :config
  (add-hook 'list-mode-hook #'paredit-everywhere-mode))
(use-package highlight-parentheses
  :config
  (global-highlight-parentheses-mode))
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode))

(use-package flycheck
  :init (global-flycheck-mode))
;; TOOD: disable flycheck warnings and info error levels

(use-package yasnippet
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-global-mode 1))

(use-package string-inflection
  :bind ("C-c C-u" . string-inflection-all-cycle))
;; TODO: use string-inflection-java-style-cycle for java major mode
;; TODO: bind to better keys which all smooth cycling between naming schemes
;; TODO: bind keys to force a particular naming scheme
;; TODO: checkout https://github.com/ninrod/evil-string-inflection and https://github.com/strickinato/evil-briefcase for evil mode bindings

;; TODO: rotate text

;; TODO: auto import/include

(defun find-config ()
  "Edit config.org"
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c i") 'find-config)
