# get the main webpage
curl https://www.sportsmans.com > index.html
# in the html, select the nav bar, select list in json, and get a list of title / href

cat index.html | pup 'nav' | pup 'li a attr{href}' | grep -P '^\/.+\/cat\d+$' | sort | uniq > category-links-list.txt
# such as
#
# /womens-shirts/c/cat101163
# /womens-shirts/c/cat129401
# /womens-shoes/c/cat139666
# /womens-winter-boots/c/cat101573
# /work-boots/c/cat101541
# /workwear/c/cat101283
# /wrist-and-bow-slings/c/cat100518
# /youth/c/cat101463



# for each link extension, build up the page
for cat in (cat category-links-list.txt)
  echo $cat
  set name (echo $cat | awk -F/ '{print $NF}') # e.g. cat100466
  echo $name
  curl https://www.sportsmans.com/"$cat" > $name.html
end

# now we have a bunch of files cat100466.html , .... etc.

cat $name.html | pup 'div[class=product-item] h2[class=details]'


# create a new sqlite database to store all this data we're gonna scrape
sqlite3 sportsmans.db
CREATE TABLE products(
  productid VARCHAR(30) PRIMARY KEY,
  href TEXT,
  description TEXT,
  fullname TEXT,
  price REAL);

# inserting the product data would be
# sqlite3 -line test.db 'insert into products values("p53209", "/shooting-gear-gun-supplies/handguns/magnum-research-desert-eagle-mark-xix-6in-white-matte-distressed-pistol/p/p53209", "Magnum Research Desert Eagle Mark XIX 6in White Matte Distressed Pistol", "Magnum Research Desert Eagle Mark XIX 6in White Matte Distressed Pistol", 1699.99)'

