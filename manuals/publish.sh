#!/bin/bash

mydir=$(dirname $(readlink -f $BASH_SOURCE))
cd $mydir


/usr/bin/emacs --batch -Q -l publish.el \
               --eval '(org-publish-project "wct-manual")'
/usr/bin/pandoc --toc-depth=2 -N -o web/manual.epub \
                epub-title.txt web/manual.md
cp *.org web/

localweb="../../../wirecell.github.io"
if [ -d $localweb ] ; then
   echo "'deploying' to web"
   cp -a web/* $localweb
fi

