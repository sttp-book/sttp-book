# #!/bin/bash

GITBOOK_REP=$1
SUMMARY_FILE="SUMMARY.md"
echo $OUTPUT_FILE

if [ -d "$GITBOOK_REP" ]; then

  echo "Entering directory '$GITBOOK_REP'..."
  cd $GITBOOK_REP
  if [ -f "$SUMMARY_FILE" ]; then
    # read summary and get texts by order in a single big file
    # we replace: 
    #   hint tip and working by --- markdown block
    #   $$ -> $ (for latex math mode)
    pandoc $SUMMARY_FILE -t html | \
      grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
      sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'| \
      xargs cat | \
      sed 's/\$\$/\$/g' | \
      perl -pe "s/{% hint style='tip' %}/***\n**_Tip:_** /g" | \
      perl -pe "s/{% hint style='working' %}/***\n**_TODO:_** /g" | \
      perl -pe 's/{% endhint %}/\n***/g' | \
      perl -pe 's/{% include "\/includes\/youtube.md" %}//g' | \
      perl -pe 's/{% set video_id = "([A-Za-z0-9-_]*)" %}/***\nWatch our video on YouTube:\n\nhttp:\/\/www.youtube.com\/embed\/\1\n\n***/g' | \
      pandoc -f markdown -t html --mathjax --filter ./filter.py | \
      pandoc -f html+tex_math_single_backslash \
              --variable fontsize=11pt \
              --variable=geometry:b5paper \
              --variable mainfont="Georgia" \
              --variable documentclass=book \
              -H latex-conf/head.tex \
              -V subparagraph \
              --resource-path="./:chapters/getting-started/:chapters/intelligent-testing:chapters/pragmatic-testing:chapters/testing-techniques:chapters/appendix" \
             --toc --toc-depth=3 --pdf-engine=lualatex -o book.pdf
  else
    echo "File '$SUMMARY_FILE' does not exist"
  fi
else
echo "Directory '$GITBOOK_REP' does not exist"
fi

