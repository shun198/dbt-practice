
  create view "postgres"."dbt_dev"."user_name__dbt_tmp"
    
    
  as (
    select
	"id",
	concat("first_name", ' ', "last_name") as full_name
from
	"postgres"."dbt_dev"."users"
  );