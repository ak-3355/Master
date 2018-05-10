create or replace view all_function_source_code as 
 select upper(p.pronamespace::regnamespace::text)::character varying(128) as owner
       ,upper(p.proname::text)::character varying(128) as name
       ,'FUNCTION'::character varying(12) as type
       ,a.line::numeric as line
       ,a.text::character varying(4000) as text
       ,upper(p.proowner::regrole::text)::character varying(128) as object_owner
   from pg_proc p,
        lateral unnest(string_to_array(pg_get_functiondef(p.oid), chr(10))) with ordinality a(text, line)
  where p.proisagg = false;

alter table all_function_source_code owner to postgres;
grant all on table all_function_source_code to postgres;
