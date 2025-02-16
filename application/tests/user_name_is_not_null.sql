-- full_nameがNULLの時、idを返すテスト
select
    id
from
    {{ ref('user_name') }}
where
    full_name is null
