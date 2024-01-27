-- Скрипт 1: Изменение цены продукта
BEGIN TRANSACTION
 ;
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE products SET price = price * 2 WHERE id = 1;
COMMIT;