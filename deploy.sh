gitbook build
cd ../sttp-book.github.io

git pull origin master

rm -rf assets/ chapters/ gitbook/ gitbook_to_pdf.sh index.html search_index.json
cp -r ../sttp-book/_book/* .

rm -rf drawio 
rm -rf answers 
rm -rf includes 
rm -rf latex-conf
rm *.sh

git add -A
git commit -am "deploy"
git push origin master
cd ../sttp-book
