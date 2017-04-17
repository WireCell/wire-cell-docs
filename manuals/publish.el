(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-html)
(message (format "org-mode version %s" org-version))

;; https://github.com/fniessen/org-html-themes
;; $ emacs --batch -Q -l ../publish.el --eval '(org-publish-project "wct-manual")'
;;; Note, this is meant to be run in a sub directory of that which
;;; holds the Org source.
(setq org-publish-project-alist
      '(("wct-manual"
         :components (
                      "wct-manual-html"
;; need to get some latex to deal with begin_hint, begin_warning, etc
                      "wct-manual-md"
                      ))

        ("wct-index-html"
         :base-directory ".."
         :publishing-directory "."
         :publishing-function (org-html-publish-to-html)
         :base-extension "does-not-exist"
         :include ("index.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )
        ("wct-manual-html"
         :base-directory ".."
         :publishing-directory "."
         :publishing-function (org-html-publish-to-html)
         :base-extension "does-not-exist"
         :include ("manual.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )

        ("wct-manual-pdf"
         :base-directory ".."
         :publishing-directory "."
         :publishing-function (org-latex-publish-to-pdf)
         :base-extension "does-not-exist"
         :include ("manual.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )

        ("wct-manual-md"
         :base-directory ".."
         :publishing-directory "."
         :publishing-function (org-gfm-publish-to-gfm)
         :base-extension "does-not-exist"
         :include ("manual.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )


        ))





