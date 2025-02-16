select
    id
from
    {{ ref('users') }}
where
    full_name is null
