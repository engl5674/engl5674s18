#!/bin/sh

y="`pwd`/$1"
echo Will create a searchable PDF for $y

x=`basename "$y"`
name=${x%.*}

mkdir "$name"
cd "$name"

# splitting to individual pages
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=jpeg -r300 -dTextAlphaBits=4 -o out_%04d.jpg -f "$y"

# process each page
for f in $( ls *.jpg ); do
  # extract text
  tesseract -l eng -psm 3 $f ${f%.*} pdf
  rm $f
done

# combine all pages back to a single file
gs -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=../${name}_searchable.pdf *.pdf

cd ..
rm -rf $name