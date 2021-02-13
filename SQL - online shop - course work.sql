DROP DATABASE IF EXISTS eshop;
CREATE DATABASE eshop;
USE eshop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название каталога',
  UNIQUE unique_name(name(10)),
  index catalog_id (id)
) COMMENT = 'Каталоги интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Платья'),
  (NULL, 'Юбки'),
  (NULL, 'Брюки'),
  (NULL, 'Костюмы'),
  (NULL, 'Блузки');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Екатерина', '1990-10-05'),
  ('Наталья', '1994-11-12'),
  ('Надежда', '1995-05-20'),
  ('Ирина', '1988-02-14'),
  ('Дарья', '1988-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS items;
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id),
  FOREIGN KEY (catalog_id) REFERENCES catalogs(id)
) COMMENT = 'Товар'
;

INSERT INTO items
  (name, description, price, catalog_id)
VALUES
  ('Zarina-7359', 'Юбка-карандаш.', 9990.00, 2),
  ('Zara-9895', 'Платье-мини.', 12990.00, 1),
  ('Massimo dutti-7876', 'Брюки-клеш от бедра.', 8990.00, 3),
  ('Hugo Boss-6463', 'Блузка приталенная.', 5990.00, 5),
  ('Tommy Hilfiger-3836', 'Костюм slim-fit.', 17990.00, 4);
  
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO media_types
  (id, name, created_at, updated_at)
VALUES
  (1, 'ghj', '2020-06-16 07:10:49', '2020-06-16 07:20:49'),
  (2, 'ghjnn', '2020-06-17 08:10:49', '2020-06-16 08:20:49'),
  (3, 'dhghg', '2020-06-18 09:10:49', '2020-06-16 09:20:49');

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    item_id BIGINT UNSIGNED NOT NULL,
    filename VARCHAR(255),    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (item_id) REFERENCES items(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

INSERT INTO media 
   (id, media_type_id, item_id, filename, size, metadata, created_at, updated_at) 
VALUES 
(1, 2, 1, 'abcd', 316921, NULL, '2020-10-21 05:43:39', '2020-03-04 22:35:21'),
(2, 2, 2, 'efgh', 316922, NULL, '2020-10-22 05:43:39', '2020-03-05 22:35:21'),
(3, 1, 3, 'ijkl', 316923, NULL, '2020-10-23 05:43:39', '2020-03-06 22:35:21'),
(4, 2, 4, 'mnop', 316924, NULL, '2020-10-24 05:43:39', '2020-03-07 22:35:21');

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

INSERT INTO orders 
	(id, user_id, created_at, updated_at)
VALUES
  (1, 1, '2020-06-16 07:10:49', '2020-06-16 07:20:49'),
  (2, 2, '2020-06-17 08:10:49', '2020-06-16 08:20:49'),
  (3, 3, '2020-06-18 09:10:49', '2020-06-16 09:20:49'),
  (4, 4, '2020-06-19 06:10:49', '2020-06-16 06:20:49');

DROP TABLE IF EXISTS orders_items;
CREATE TABLE orders_items (
  id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED,
  item_id BIGINT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товаров',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (item_id) REFERENCES items(id)
) COMMENT = 'Состав заказа';

INSERT INTO orders_items
	(id, order_id, item_id, total, created_at, updated_at)
VALUES
  (1, 1, 3, 1, '2020-06-16 07:10:49', '2020-06-16 07:20:49'),
  (2, 2, 3, 1, '2020-06-17 08:10:49', '2020-06-16 08:20:49'),
  (3, 3, 1, 1, '2020-06-18 09:10:49', '2020-06-16 09:20:49'),
  (4, 4, 2, 1, '2020-06-19 06:10:49', '2020-06-16 06:20:49');

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  item_id BIGINT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_item_id(item_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (item_id) REFERENCES items(id)
) COMMENT = 'Скидки';

INSERT INTO discounts
	(id, user_id, item_id, discount, started_at, finished_at, created_at, updated_at)
VALUES
  (1, 1, 3, 0.5, '2020-06-16 00:00:00', '2020-06-26 00:00:00', '2020-06-16 07:10:49', '2020-06-16 07:20:49'),
  (2, 2, 3, 0.25, '2020-06-10 00:00:00', '2020-06-20 00:00:00', '2020-06-17 08:10:49', '2020-06-16 08:20:49'),
  (3, 3, 1, 0.3, '2020-06-10 00:00:00', '2020-06-20 00:00:00', '2020-06-18 09:10:49', '2020-06-16 09:20:49'),
  (4, 4, 2, 0.15, '2020-06-16 00:00:00', '2020-06-26 00:00:00', '2020-06-19 06:10:49', '2020-06-16 06:20:49');

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses
	(id, name, created_at, updated_at)
VALUES
  (1, 'Ракета', '2020-06-16 07:10:49', '2020-06-16 07:20:49'),
  (2, 'АБВ', '2020-06-17 08:10:49', '2020-06-16 08:20:49'),
  (3, 'Максимум', '2020-06-18 09:10:49', '2020-06-16 09:20:49'),
  (4, 'Опт', '2020-06-19 06:10:49', '2020-06-16 06:20:49');

DROP TABLE IF EXISTS storehouses_items;
CREATE TABLE storehouses_items (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED,
  item_id BIGINT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товара на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (storehouse_id) REFERENCES storehouses(id),
  FOREIGN KEY (item_id) REFERENCES items(id)
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_items
	(id, storehouse_id, item_id, value, created_at, updated_at)
VALUES
  (1, 1, 1, 35, '2020-06-16 07:10:49', '2020-06-16 07:20:49'),
  (2, 1, 2, 85, '2020-06-17 08:10:49', '2020-06-16 08:20:49'),
  (3, 2, 2, 102, '2020-06-18 09:10:49', '2020-06-16 09:20:49'),
  (4, 3, 4, 34, '2020-06-19 06:10:49', '2020-06-16 06:20:49');
