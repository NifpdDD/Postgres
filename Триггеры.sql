CREATE TABLE spec (
id integer NOT NULL PRIMARY KEY,
table_name VARCHAR NOT NULL,
column_name VARCHAR NOT NULL,
max_val INTEGER NOT NULL
);

CREATE TABLE "test pivo"(
id integer NOT NULL
);

CREATE TABLE test2 (
num_value1 integer NOT NULL,
num_value2 integer NOT NULL
);

INSERT INTO spec VALUES (1, 'spec', 'id', 1);

CREATE OR REPLACE FUNCTION update_spec_table()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
maximum INTEGER;
BEGIN
EXECUTE format('SELECT MAX(%s) FROM new_table', quote_ident(TG_ARGV[0])) INTO maximum;
UPDATE spec SET max_val = maximum WHERE table_name = TG_TABLE_NAME AND column_name = TG_ARGV[0] AND maximum > max_val;
RETURN new;
END
$$;

CREATE OR REPLACE FUNCTION get_next_number(tbl_name VARCHAR, clmn_name VARCHAR, out _max_id INTEGER)
LANGUAGE plpgsql
AS
$$
BEGIN
UPDATE spec SET max_val = max_val + 1
WHERE table_name = tbl_name AND column_name = clmn_name
RETURNING max_val INTO _max_id;
IF _max_id IS NULL
THEN
EXECUTE format('SELECT COALESCE(MAX(%s) + 1, 1) FROM %s', quote_ident(clmn_name), quote_ident(tbl_name)) INTO _max_id;
EXECUTE ('CREATE OR REPLACE TRIGGER ' || quote_ident(tbl_name || '_' || clmn_name || '_INSERT') ||
' AFTER INSERT ON ' || quote_ident(tbl_name) || ' REFERENCING NEW TABLE AS new_table ' ||
' FOR EACH STATEMENT EXECUTE FUNCTION update_spec_table (' || quote_literal(clmn_name) || ')');
EXECUTE ('CREATE OR REPLACE TRIGGER ' || quote_ident(tbl_name || '_' || clmn_name || '_UPDATE') ||
' AFTER UPDATE ' || ' ON ' || quote_ident(tbl_name) ||' REFERENCING NEW TABLE AS new_table ' ||
' FOR EACH STATEMENT EXECUTE FUNCTION update_spec_table (' || quote_literal(clmn_name) || ')');
INSERT INTO spec VALUES(get_next_number('spec', 'id'), tbl_name, clmn_name, _max_id);
END IF;
END
$$;

SELECT * FROM spec;
INSERT INTO "test pivo" VALUES (10);
SELECT get_next_number('test pivo', 'id');
SELECT * FROM spec;
INSERT INTO test VALUES (5);
SELECT get_next_number('test', 'id');
SELECT * FROM spec;
INSERT INTO test VALUES (3), (15), (4);
SELECT get_next_number('test', 'id');
SELECT * FROM spec;
INSERT INTO test VALUES (7), (8);
SELECT get_next_number('test', 'id');
SELECT * FROM spec;
INSERT INTO test VALUES (20), (30);
SELECT get_next_number('test', 'id');
SELECT * FROM spec;



SELECT get_next_number('test2', 'num_value1');
SELECT get_next_number('test2', 'num_value2');
SELECT * FROM spec;
INSERT INTO test2 VALUES (10, 20);
SELECT get_next_number('test2', 'num_value1');
SELECT get_next_number('test2', 'num_value2');
SELECT * FROM spec;
INSERT INTO test2 VALUES (5, 5);
SELECT get_next_number('test2', 'num_value1');
SELECT get_next_number('test2', 'num_value2');
SELECT * FROM spec;
INSERT INTO test2 VALUES (40, 50), (60, 70);
SELECT get_next_number('test2', 'num_value1');
SELECT get_next_number('test2', 'num_value2');
SELECT * FROM spec;
INSERT INTO test2 VALUES (1, 1), (61, 71);
SELECT get_next_number('test2', 'num_value1');
SELECT get_next_number('test2', 'num_value2');
SELECT * FROM spec;
INSERT INTO test2 VALUES (30, 2), (2, 30);
SELECT get_next_number('test2', 'num_value1');
SELECT get_next_number('test2', 'num_value2');
SELECT * FROM spec;

DROP FUNCTION get_next_number(tbl_name VARCHAR, clmn_name VARCHAR);
DROP TABLE "test pivo";
DROP TABLE test2;
DROP TABLE spec;
DROP FUNCTION update_spec_table;
