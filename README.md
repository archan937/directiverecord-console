## DirectiveRecord console

Use DirectiveRecord (https://github.com/archan937/directiverecord) within a simple Pry console

### Installation

Clone this repository:

    git clone git@github.com:archan937/directiverecord-console.git

Install `Gemfile` dependencies:

    $ bundle install

Alter `config/database.yml` if necessary and run:

    $ rake db:install

### Using the console

The console is a Pry console in which you can play with `DirectiveRecord` using the database you just installed:

```ruby
  $ script/console
  Loading DirectiveRecord console (0.1.28)
```
```ruby
  [1] pry(main)> puts Customer.to_qry("id", "name", "COUNT(orders.id) AS order_count", "GROUP_CONCAT(DISTINCT tags.name) AS tags", :group_by => "id", :order_by => "COUNT(DISTINCT tags.id) DESC", :limit => 5)
```
```sql
  SELECT
    `c`.id,
    `c`.name,
    COUNT(`orders`.id) AS order_count,
    GROUP_CONCAT(DISTINCT `tags`.name) AS tags
  FROM customers `c`
  LEFT JOIN orders `orders` ON `orders`.customer_id = `c`.id
  LEFT JOIN customers_tags `tags_bridge_table` ON `tags_bridge_table`.customer_id = `c`.id
  LEFT JOIN tags `tags` ON `tags`.id = `tags_bridge_table`.tag_id
  GROUP BY `c`.id
  ORDER BY COUNT(DISTINCT `tags`.id) DESC
  LIMIT 5
```
```ruby
  [2] pry(main)> Customer.qry("id", "name", "COUNT(orders.id) AS order_count", "GROUP_CONCAT(DISTINCT tags.name) AS tags", :group_by => "id", :order_by => "COUNT(DISTINCT tags.id) DESC", :limit => 5)
  => [[119, "La Rochelle Gifts", 8, "gifts,posters"],
   [112, "Signal Gift Stores", 3, "gifts"],
   [124, "Mini Gifts Distributors Ltd.", 17, "gifts"],
   [103, "Atelier graphique", 3, nil],
   [114, "Australian Collectors, Co.", 5, nil]]
```
```ruby
  [3] pry(main)> puts Customer.where("tags.name LIKE ?", "%gifts%").to_qry
```
```sql
  SELECT `c`.*
  FROM customers `c`
  LEFT JOIN customers_tags `tags_bridge_table` ON `tags_bridge_table`.customer_id = `c`.id
  LEFT JOIN tags `tags` ON `tags`.id = `tags_bridge_table`.tag_id
  WHERE (`tags`.name LIKE '%gifts%')
```
```ruby
  [4] pry(main)> Customer.where("tags.name LIKE ?", "%gifts%").qry
  => => [[112, 1166, "Signal Gift Stores", "Jean", "King", "7025551838", "8489 Strong St.", nil, "83030", "Las Vegas", "NV", "USA", #<BigDecimal:7fa838f74d28,'0.718E5',9(18)>],
   [119, 1370, "La Rochelle Gifts", "Janine ", "Labrune", "40.67.8555", "67, rue des Cinquante Otages", nil, "44000", "Nantes", nil, "France", #<BigDecimal:7fa838f74a30,'0.1182E6',9(18)>],
   [124, 1165, "Mini Gifts Distributors Ltd.", "Susan", "Nelson", "4155551450", "5677 Strong St.", nil, "97562", "San Rafael", "CA", "USA", #<BigDecimal:7fa838f745f8,'0.2105E6',9(18)>]]
```
```ruby
  [5] pry(main)> puts Customer.where("tags.name LIKE ?", "%gifts%").group("tags.id").to_qry("tags.*")
```
```sql
  SELECT `tags`.*
  FROM customers `c`
  LEFT JOIN customers_tags `tags_bridge_table` ON `tags_bridge_table`.customer_id = `c`.id
  LEFT JOIN tags `tags` ON `tags`.id = `tags_bridge_table`.tag_id
  WHERE (`tags`.name LIKE '%gifts%')
  GROUP BY `tags`.id
```
```ruby
  [6] pry(main)> puts Customer.to_qry("id", "name", "COUNT(orders.id) AS order_count", :where => "order_count > 3", :group_by => "id")
```
```sql
  SELECT `c`.id, `c`.name, COUNT(`orders`.id) AS order_count
  FROM customers `c`
  LEFT JOIN orders `orders` ON `orders`.customer_id = `c`.id
  GROUP BY `c`.id
  HAVING (order_count > 3)
```
```ruby
  [7] pry(main)> Customer.qry("id", "name", "COUNT(orders.id) AS order_count", :where => "order_count > 3", :group_by => "id")
  => [[114, "Australian Collectors, Co.", 5],
   [119, "La Rochelle Gifts", 4],
   [121, "Baane Mini Imports", 4],
   [124, "Mini Gifts Distributors Ltd.", 17],
   [128, "Blauer See Auto, Co.", 4],
   [131, "Land of Toys Inc.", 4],
   [141, "Euro+ Shopping Channel", 26],
   [144, "Volvo Model Replicas, Co", 4],
   [145, "Danish Wholesale Imports", 5],
   [148, "Dragon Souveniers, Ltd.", 5],
   [151, "Muscle Machine Inc", 4],
   [157, "Diecast Classics Inc.", 4],
   [161, "Technics Stores Inc.", 4],
   [166, "Handji Gifts& Co", 4],
   [276, "Anna's Decorations, Ltd", 4],
   [282, "Souveniers And Things Co.", 4],
   [321, "Corporate Gift Ideas Co.", 4],
   [323, "Down Under Souveniers, Inc", 5],
   [353, "Reims Collectables", 5],
   [381, "Royale Belge", 4],
   [382, "Salzburg Collectables", 4],
   [398, "Tokyo Collectables, Ltd", 4],
   [450, "The Sharp Gifts Warehouse", 4],
   [496, "Kelly's Gift Shop", 4]]
```

### Check out the gem!

Check out the `DirectiveRecord` repository at [https://github.com/archan937/directiverecord](https://github.com/archan937/directiverecord).

### License

Copyright (c) 2015 Paul Engel, released under the MIT License

http://github.com/archan937 – http://twitter.com/archan937 – http://gettopup.com – pm_engel@icloud.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
