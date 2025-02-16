# dbt-practice

## プロジェクトの立ち上げ方

以下のコマンドで Postgres 用のコンテナを立ち上げてください

```
make prepare
```

コマンドを実行すると Postgres のコンテナが立ち上がり、init.sql が実行されます
dbt_dev のスキーマにテーブルとデータが作成されます
以下のコマンドで Postgres のコンテナに入り、テーブルおよびデータがあることを確認できれば成功です

```
docker exec -it db bash
root@a1c3e2cf55fb:/# psql -U postgres
psql (17.3 (Debian 17.3-1.pgdg120+1))
Type "help" for help.

postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
postgres=# \dt dbt_dev.*
         List of relations
 Schema  | Name  | Type  |  Owner
---------+-------+-------+----------
 dbt_dev | todos | table | postgres
 dbt_dev | users | table | postgres
(2 rows)

postgres=# select * from "dbt_dev"."todos";
 id |     title      |           description           | priority | complete
----+----------------+---------------------------------+----------+----------
  1 | Buy groceries  | Buy milk, eggs, and bread       |        2 | f
  2 | Finish project | Complete the database migration |        1 | f
  3 | Call mom       | Check in with mom and chat      |        3 | t
(3 rows)

postgres=# select * from "dbt_dev"."users";
 id |       email       | username | first_name | last_name |    password     | is_active | role  | phone_number
----+-------------------+----------+------------+-----------+-----------------+-----------+-------+--------------
  1 | user1@example.com | user1    | John       | Doe       | hashedpassword1 | t         | admin | 123-456-7890
  2 | user2@example.com | user2    | Jane       | Smith     | hashedpassword2 | t         | user  | 234-567-8901
  3 | user3@example.com | user3    | Alice      | Johnson   | hashedpassword3 | f         | user  | 345-678-9012
(3 rows)
```

## uv を使って dbt run を実行する

application 配下に移動し、venv を起動します

```
cd application
source .venv/bin/activate
```

dbt run コマンドを実行し、view が作成されたら成功です

```
dbt run
01:45:28 Running with dbt=1.9.2
01:45:28 Registered adapter: postgres=1.9.0
01:45:28 [WARNING]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:

- models.application
  01:45:28 Found 1 model, 433 macros
  01:45:28
  01:45:28 Concurrency: 1 threads (target='dev')
  01:45:28
  01:45:29 1 of 1 START sql view model dbt_dev.user_name .................................. [RUN]
  01:45:29 1 of 1 OK created sql view model dbt_dev.user_name ............................. [CREATE VIEW in 0.10s]
  01:45:29
  01:45:29 Finished running 1 view model in 0 hours 0 minutes and 0.28 seconds (0.28s).
  01:45:29
  01:45:29 Completed successfully
  01:45:29
  01:45:29 Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1

```

view が作成されていることを確認できました

```
postgres=# select \* from dbt_dev.user_name;
id | full_name
----+---------------
1 | John Doe
2 | Jane Smith
3 | Alice Johnson
(3 rows)

```

view の一覧は以下のコマンドを実行すれば確認できます

```
postgres=# \dv dbt_dev.*
           List of relations
 Schema  |   Name    | Type |  Owner
---------+-----------+------+----------
 dbt_dev | user_name | view | postgres
(1 row)
```
