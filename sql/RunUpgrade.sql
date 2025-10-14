create or replace function     upgrade()
returns text
as
'
        declare
                ver text := '' '';
        begin
                select ip360_version into ver from nc_version;
                raise info ''[ INFO ] Success at nc_version'';

                RETURN ''[ INFO ] Upgrade to 6.8.5.1 successful'';
        EXCEPTION WHEN OTHERS THEN
                raise info ''[ ERROR ] Upgrade to 6.8.5.1 failed'';
                RETURN ''[ ERROR ] Upgrade to 6.8.5.1 failed'';
        end;
'
language 'plpgsql';
