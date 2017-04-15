(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-html)
(message (format "org-mode version %s" org-version))

;; https://github.com/fniessen/org-html-themes
;; $ emacs --batch -Q -l publish.el --eval '(org-publish-project "wct-manual")'


(setq org-publish-project-alist
      '(("wct-manual"
         :components (
                      "wct-manual-html"
                      "wct-manual-styles"
;; need to get some latex to deal with begin_hint, begin_warning, etc
;;                      "wct-manual-pdf"
                      "wct-manual-md"
                      ))

        ("wct-manual-html"
         :base-directory "."
         :publishing-directory "web"
         :publishing-function (org-html-publish-to-html)
         :base-extension "does-not-exist"
         :include ("manual.org" "index.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )

        ("wct-manual-styles"
         :base-directory "org-html-themes/styles"
         :publishing-directory "web/styles/"
         :publishing-function (org-publish-attachment)
         :base-extension "css\\|js\\|png"
         :recursive t
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )

        ("wct-manual-pdf"
         :base-directory "."
         :publishing-directory "web"
         :publishing-function (org-latex-publish-to-pdf)
         :base-extension "does-not-exist"
         :include ("manual.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )

        ("wct-manual-md"
         :base-directory "."
         :publishing-directory "web"
         :publishing-function (org-gfm-publish-to-gfm)
         :base-extension "does-not-exist"
         :include ("manual.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )

        ("wct-manual-md"
         :base-directory "."
         :publishing-directory "web"
         :publishing-function (org-pandoc-export-to-epub)
         :base-extension "does-not-exist"
         :include ("manual.org")
         :recursive nil
         :htmlized-source t
         :auto-sitemap nil
         :makeindex nil
         )
        


        ))





