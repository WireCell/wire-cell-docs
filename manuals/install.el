;; load this if you do not have the required Emacs packages.
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-refresh-contents)
(package-install 'org-plus-contrib)
(package-install 'ox-gfm)

