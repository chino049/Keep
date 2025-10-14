CREATE OR REPLACE FUNCTION findbadrows() RETURNS SETOF integer AS
\$BODY$
DECLARE
        rowcount INTEGER;
        t1id INTEGER;
        r INTEGER;
BEGIN
        <<outer>>
        FOR rowcount IN SELECT count(*) from $TABLE LOOP
                <<inner>>
                FOR r in select $KEY from $TABLE where (select $KEY from $TABLE offset rowcount limit 1) not in (select $FKEY from $FTABLE) LOOP
                        RETURN NEXT r;
                END LOOP inner;
        END LOOP outer;
        RETURN;
END;
\$BODY$
LANGUAGE plpgsql;

