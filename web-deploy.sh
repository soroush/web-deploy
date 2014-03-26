#!/bin/sh

echo "Compressing CSS files..."
for css in `find . -type f -name \*.css -print`
do
    echo "Compressing $css"
    temp="$css.temp.css"
    yui-compressor --charset utf-8 --type css "$css" -o "$temp"
    mv $temp $css
done

echo "Compressing JavaScript files..."
for js in `find . -type f -name \*.js -print`
do
    echo "Compressing $js"
    temp="$js.temp.js"
    yui-compressor --charset utf-8 --type js "$js" -o "$temp"
    mv $temp $js
done

echo "Compressing HTML files..."
for html in `find . -path ./.backups -prune -o -type f -regex .*\."\(html\|htm\|php\)"$ -print`
do
    echo "Compressing $html"
    ./html-minify.sh $html
done

echo "Commiting changes"
git commit -a -m "Changed on `date`"

echo "Uploading files to server"
git ftp push --user $1 --passwd $2 $3

echo "Expanding CSS files..."
for css in `find . -type f -name \*.css -print`
do
    echo "Expanding $css"
    temp="$css.tmp"
    cp $css $temp
    cssunminifier $temp > $css
    rm $temp
done

echo "Expanding JavaScript files..."
for js in `find . -type f -name \*.js -print`
do
    echo "Expanding $js"
    js-beautify $js
done

echo "Revert back HTML and PHP files..."
# TODO find correct regex
cp -v -r ./.backups/* ./

echo "Commiting uncompressed files"
git commit -a -m "Uncompressed on `date`"