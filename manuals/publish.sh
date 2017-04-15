#!/bin/bash


/usr/bin/emacs --batch -Q -l publish.el \
               --eval '(org-publish-project "wct-manual")'
/usr/bin/pandoc --toc-depth=2 -N -o web/manual.epub \
                epub-title.txt web/manual.md
