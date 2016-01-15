-- Verify table.dim.specialty on pg

do language plpgsql $$
begin
  perform (
    select table_name
    from information_schema.tables
    where
      table_type = 'BASE TABLE' and
      table_schema = 'dim' and
      table_name = 'specialty'
  );
  
  if not found then
    raise exception 'Sqitch Verification Error (table.dim.specialty)', '';
  end if;
end; $$
