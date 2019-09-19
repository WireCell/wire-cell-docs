(TeX-add-style-hook
 "img"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "xcolor=dvipsnames")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("adjustbox" "export") ("contour" "outline")))
   (add-to-list 'LaTeX-verbatim-environments-local "semiverbatim")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "defaults"
    "beamer/preamble"
    "beamer"
    "beamer10"
    "svg"
    "wasysym"
    "siunitx"
    "xmpmulti"
    "adjustbox"
    "ulem"
    "contour"
    "pdfpages"
    "tikz")
   (TeX-add-symbols
    "Put")
   (LaTeX-add-xcolor-definecolors
    "bvtitlecolor"
    "bvoutline"))
 :latex)

