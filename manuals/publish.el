
(require 'package)
(setq package-user-dir (concat (file-name-directory load-file-name) "/build/emacsd/elpa/"))
(package-initialize)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(setq package-user-dir "/tmp/elisp")
(package-initialize)
(package-refresh-contents)
(package-install 'org-plus-contrib)
;;(package-install 'org)
(package-install 'ox-gfm)

(require 'org)
(require 'ox)
(require 'ox-html)
(require 'ox-gfm)




(message (format "org-mode version %s" org-version))

(setq org-publish-use-timestamps-flag nil)

(defun wct-html-headline (headline contents info)
  "Transcode headline from org to WCT HTML"
  (let* ((text (and contents (org-html-headline headline contents info)))
         (ids (delq nil
                    (list (org-element-property :CUSTOM_ID headline)
                          (org-export-get-reference headline info)
                          (org-element-property :ID headline))))
         (slug (car ids)))
    (with-temp-buffer
      (insert text)
      (goto-char (point-min))
      ;; this seems dodgy as fsck
      (if (not (search-forward "<h" nil t))
          text
        (search-forward ">")
        (insert
         (format
          "<a id=\"user-content-%s\" class=\"anchor\" href=\"#%s\" aria-hidden=\"true\"><svg aria-hidden=\"true\" class=\"octicon octicon-link\" height=\"16\" version=\"1.1\" viewBox=\"0 0 16 16\" width=\"16\"><path fill-rule=\"evenodd\" d=\"M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z\"></path></svg></a>"
          slug slug))
        (buffer-string)))))

(defun wct-html-export-as-html
    (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to an HTML buffer."
  (interactive)
  (org-export-to-buffer 'wct-html "*Org WCT HTML Export*"
    async subtreep visible-only body-only ext-plist
    (lambda () (set-auto-mode t))))

(defun wct-html-export-to-html
    (&optional async subtreep visible-only body-only ext-plist)
    "Export current buffer to a HTML file."
    (interactive)
    (let* ((extension (concat "." (or (plist-get ext-plist :html-extension)
                                      org-html-extension
                                      "html")))
           (file (org-export-output-file-name extension subtreep))
           (org-export-coding-system org-html-coding-system))
      (org-export-to-file 'wct-html file
        async subtreep visible-only body-only ext-plist)))

(defun wct-html-publish-to-html (plist filename pub-dir)
    "Publish an org file to HTML."
    (org-publish-org-to 'wct-html filename
                        (concat "." (or (plist-get plist :html-extension)
                                        org-html-extension
                                        "html"))
                        plist pub-dir))

  

(org-export-define-derived-backend 'wct-html 'html
  :menu-entry
  '(?w "Export to WCT HTML"
       ((?H "As WCT HTML buffer" wct-html-export-as-html)
        (?h "As WCT HTML file" wct-html-export-to-html)
        (?o "As WCT HTML file and open"
            (lambda (a s v b)
              (if a (wct-html-export-to-html t s v b)
                (org-open-file (wct-html-export-to-html nil s v b)))))))
  :translate-alist '((headline . wct-html-headline)))
       



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
         :publishing-function (wct-html-publish-to-html)
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
         :publishing-function (wct-html-publish-to-html)
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





