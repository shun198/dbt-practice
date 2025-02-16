select
	"id",
	concat("first_name", ' ', "last_name") as full_name
from
	"postgres"."dbt_dev"."users"