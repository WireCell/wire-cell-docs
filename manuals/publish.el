(package-initialize)
(require 'org)
(require 'ox)
(require 'ox-html)
(message (format "org-mode version %s" org-version))

;; ugly hack to inject some stuff into HTML headlines.  Maybe there is a better way to do this.
(defun org-html-headline (headline contents info)
  "Transcode a HEADLINE element from Org to HTML.
CONTENTS holds the contents of the headline.  INFO is a plist
holding contextual information."
  (unless (org-element-property :footnote-section-p headline)
    (let* ((numberedp (org-export-numbered-headline-p headline info))
           (numbers (org-export-get-headline-number headline info))
           (level (+ (org-export-get-relative-level headline info)
                     (1- (plist-get info :html-toplevel-hlevel))))
           (todo (and (plist-get info :with-todo-keywords)
                      (let ((todo (org-element-property :todo-keyword headline)))
                        (and todo (org-export-data todo info)))))
           (todo-type (and todo (org-element-property :todo-type headline)))
           (priority (and (plist-get info :with-priority)
                          (org-element-property :priority headline)))
           (text (org-export-data (org-element-property :title headline) info))
           (tags (and (plist-get info :with-tags)
                      (org-export-get-tags headline info)))
           (full-text (funcall (plist-get info :html-format-headline-function)
                               todo todo-type priority text tags info))
           (contents (or contents ""))
	   (ids (delq nil
                      (list (org-element-property :CUSTOM_ID headline)
                            (org-export-get-reference headline info)
                            (org-element-property :ID headline))))
           (preferred-id (car ids))
           (extra-ids
	    (mapconcat
	     (lambda (id)
	       (org-html--anchor
		(if (org-uuidgen-p id) (concat "ID-" id) id)
		nil nil info))
	     (cdr ids) "")))
      (if (org-export-low-level-p headline info)
          ;; This is a deep sub-tree: export it as a list item.
          (let* ((type (if numberedp 'ordered 'unordered))
                 (itemized-body
                  (org-html-format-list-item
                   contents type nil info nil
                   (concat (org-html--anchor preferred-id nil nil info)
                           extra-ids
                           full-text))))
            (concat (and (org-export-first-sibling-p headline info)
                         (org-html-begin-plain-list type))
                    itemized-body
                    (and (org-export-last-sibling-p headline info)
                         (org-html-end-plain-list type))))
        (let ((extra-class (org-element-property :HTML_CONTAINER_CLASS headline))
              (first-content (car (org-element-contents headline))))
          ;; Standard headline.  Export it as a section.
          (format "<%s id=\"%s\" class=\"%s\">%s%s</%s>\n"
                  (org-html--container headline info)
                  (concat "outline-container-"
			  (org-export-get-reference headline info))
                  (concat (format "outline-%d" level)
                          (and extra-class " ")
                          extra-class)
                  (format "\n<h%d id=\"%s\">%s%s%s</h%d>\n"
                          level
                          preferred-id
                          extra-ids
                          (format
                                  "<a id=\"user-content-%s\" class=\"anchor\" href=\"#%s\" aria-hidden=\"true\"><svg aria-hidden=\"true\" class=\"octicon octicon-link\" height=\"16\" version=\"1.1\" viewBox=\"0 0 16 16\" width=\"16\"><path fill-rule=\"evenodd\" d=\"M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z\"></path></svg> </a>"
                                  preferred-id preferred-id)
                          (concat
                           (and numberedp
                                (format
                                 "<span class=\"section-number-%d\">%s</span> "
                                 level
                                 (mapconcat #'number-to-string numbers ".")))
                           full-text)
                          level)
                  ;; When there is no section, pretend there is an
                  ;; empty one to get the correct <div
                  ;; class="outline-...> which is needed by
                  ;; `org-info.js'.
                  (if (eq (org-element-type first-content) 'section) contents
                    (concat (org-html-section first-content "" info) contents))
                  (org-html--container headline info)))))))

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





