create table    JOP_table
(
        conName         varchar(128)

);

create or replace function GetRows(varchar) returns setof JOP_table as
'
declare
        l_cred          record ;
begin
        for l_cred in loop
                SELECT host_id  from nc_host;
                return next l_cred;
        end loop;
        return;
end
'
language 'plpgsql';

select GetRows();

drop function GetRows();
drop table JOP_table;

