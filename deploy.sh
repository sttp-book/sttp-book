gitbook build
rm -rf ../sttp-book.github.io/assets/ ../sttp-book.github.io/chapters/ ../sttp-book.github.io/gitbook/ ../sttp-book.github.io/gitbook_to_pdf.sh ../sttp-book.github.io/index.html ../sttp-book.github.io/search_index.json
cp -r _book/* ../sttp-book.github.io/
cd ../sttp-book.github.io
rm -rf drawio 
rm -rf answers 
rm -rf includes 
rm -rf latex-conf
rm *.sh
git pull
git add -A
git commit -am "deploy"
git push origin master
cd ../sttp-book

