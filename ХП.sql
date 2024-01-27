-- create a table
CREATE TABLE spec_table (
  id INT NOT NULL,
  name_table VARCHAR NOT NULL,
  name_column VARCHAR NOT NULL,
  max_value_id INT NOT NULL
);

CREATE TABLE test
(
    id integer NOT NULL
);
CREATE TABLE test2
(
    num_value1 integer NOT NULL,
    num_value2 integer NOT NULL
);

CREATE OR REPLACE FUNCTION next_max_value_id(_name_table VARCHAR, _name_column VARCHAR,out _max_id INTEGER)
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE spec_table SET max_value_id = max_value_id + 1 WHERE name_table = _name_table  AND name_column = _name_column  RETURNING max_value_id INTO _max_id;
    IF _max_id  IS NULL
        THEN
            EXECUTE format('SELECT COALESCE(MAX(%s) + 1, 1) FROM %s',quote_ident(_name_column),quote_ident(_name_table)) INTO _max_id;
            INSERT INTO spec_table VALUES (next_max_value_id('spec','id'),_name_table, _name_column, _max_id);
    END IF;
END;
$$;
INSERT INTO spec_table VALUES (1, 'spec', 'id', 1);
SELECT next_max_value_id('spec', 'id');
SELECT * FROM spec_table;
SELECT next_max_value_id('spec', 'id');
SELECT * FROM spec_table;
INSERT INTO test VALUES (10);
SELECT next_max_value_id('test', 'id');
SELECT * FROM spec_table;
SELECT next_max_value_id('test', 'id');
SELECT * FROM spec_table;
SELECT next_max_value_id('test2', 'num_value1');
SELECT * FROM spec_table;
SELECT next_max_value_id('test2', 'num_value1');
SELECT * FROM spec_table;
INSERT INTO test2 VALUES (2, 13);
SELECT next_max_value_id('test2', 'num_value2');
SELECT * FROM spec_table;
SELECT next_max_value_id('test2', 'num_value1');
SELECT next_max_value_id('test2', 'num_value1');
SELECT next_max_value_id('test2', 'num_value1');
SELECT next_max_value_id('test2', 'num_value1');
SELECT next_max_value_id('test2', 'num_value1');
SELECT * FROM spec_table;


DROP FUNCTION next_max_value_id(_name_table varchar, _name_column varchar);
DROP TABLE test;
DROP TABLE test2;
DROP TABLE spec_table;
