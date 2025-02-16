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

## dbt 用パッケージのインストール

```
dbt deps
02:14:57  Running with dbt=1.9.2
02:14:58  Updating lock file in file path: /Users/shun/dbt-practice/application/package-lock.yml
02:14:58  Installing dbt-labs/dbt_utils
02:14:58  Installed from version 1.3.0
02:14:58  Up to date!
02:14:58  Installing elementary-data/elementary
02:14:59  Installed from version 0.16.1
02:14:59  Updated version available: 0.16.4
02:14:59
02:14:59  Updates available for packages: ['elementary-data/elementary']
Update your versions in packages.yml, then run dbt deps
```

## dbt ドキュメントの生成と閲覧

```
dbt docs generate
02:23:11  Running with dbt=1.9.2
02:23:12  Registered adapter: postgres=1.9.0
02:23:12  [WARNING]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.application
02:23:12  Found 30 models, 2 operations, 1235 macros
02:23:12
02:23:12  Concurrency: 1 threads (target='dev')
02:23:12
02:23:13
IMPORTANT - Starting from dbt 1.8, users must explicitly allow packages to override materializations.
Elementary requires this ability to support collection of samples and failed row count for dbt tests.
Please add the following flag to dbt_project.yml to allow it:

flags:
  require_explicit_package_overrides_for_builtin_materializations: false

Notes -
* This is a temporary measure that will result in a deprecation warning, please ignore it for now. Elementary is working with the dbt-core team on a more permanent solution.
* This message can be muted by setting the 'mute_ensure_materialization_override' var to true.

02:23:14  Building catalog
02:23:14  Catalog written to /Users/shun/dbt-practice/application/target/catalog.json
dbt docs serve
02:23:32  Running with dbt=1.9.2
Serving docs at 8080
To access from your browser, navigate to: http://localhost:8080



Press Ctrl+C to exit.
127.0.0.1 - - [16/Feb/2025 11:23:33] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [16/Feb/2025 11:23:33] "GET /manifest.json?cb=1739672613865 HTTP/1.1" 200 -
127.0.0.1 - - [16/Feb/2025 11:23:33] "GET /catalog.json?cb=1739672613865 HTTP/1.1" 200 -
127.0.0.1 - - [16/Feb/2025 11:23:35] code 404, message File not found
127.0.0.1 - - [16/Feb/2025 11:23:35] "GET /$%7Brequire('./assets/favicons/favicon.ico')%7D HTTP/1.1" 404 -
```

## CSV 経由でテストデータを投入

```
dbt seed
02:40:42  Running with dbt=1.9.2
02:40:43  Registered adapter: postgres=1.9.0
02:40:44  [WARNING]: Configuration paths exist in your dbt_project.yml file which do not apply to any resources.
There are 1 unused configuration paths:
- models.application
02:40:44  Found 30 models, 2 operations, 2 seeds, 1235 macros
02:40:44
02:40:44  Concurrency: 1 threads (target='dev')
02:40:44
02:40:44
IMPORTANT - Starting from dbt 1.8, users must explicitly allow packages to override materializations.
Elementary requires this ability to support collection of samples and failed row count for dbt tests.
Please add the following flag to dbt_project.yml to allow it:

flags:
  require_explicit_package_overrides_for_builtin_materializations: false

Notes -
* This is a temporary measure that will result in a deprecation warning, please ignore it for now. Elementary is working with the dbt-core team on a more permanent solution.
* This message can be muted by setting the 'mute_ensure_materialization_override' var to true.

02:40:44  1 of 1 START hook: elementary.on-run-start.0 ................................... [RUN]
02:40:44  1 of 1 OK hook: elementary.on-run-start.0 ...................................... [OK in 0.06s]
02:40:44
02:40:44  1 of 2 START seed file dbt_dev.todos ........................................... [RUN]
02:40:44  1 of 2 OK loaded seed file dbt_dev.todos ....................................... [INSERT 3 in 0.14s]
02:40:44  2 of 2 START seed file dbt_dev.users ........................................... [RUN]
02:40:44  2 of 2 OK loaded seed file dbt_dev.users ....................................... [INSERT 3 in 0.07s]
02:40:44
02:40:46  1 of 1 START hook: elementary.on-run-end.0 ..................................... [RUN]
02:40:46  1 of 1 OK hook: elementary.on-run-end.0 ........................................ [OK in 1.26s]
02:40:46
02:40:46  Finished running 2 project hooks, 2 seeds in 0 hours 0 minutes and 1.80 seconds (1.80s).
02:40:46
02:40:46  Completed successfully
02:40:46
02:40:46  Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

## テストの実行

```
dbt test
03:03:51  Running with dbt=1.9.2
03:03:51  Registered adapter: postgres=1.9.0
03:03:52  Found 30 models, 2 seeds, 2 operations, 1 test, 1235 macros
03:03:52
03:03:52  Concurrency: 1 threads (target='dev')
03:03:52
03:03:52
IMPORTANT - Starting from dbt 1.8, users must explicitly allow packages to override materializations.
Elementary requires this ability to support collection of samples and failed row count for dbt tests.
Please add the following flag to dbt_project.yml to allow it:

flags:
  require_explicit_package_overrides_for_builtin_materializations: false

Notes -
* This is a temporary measure that will result in a deprecation warning, please ignore it for now. Elementary is working with the dbt-core team on a more permanent solution.
* This message can be muted by setting the 'mute_ensure_materialization_override' var to true.

03:03:52  1 of 1 START hook: elementary.on-run-start.0 ................................... [RUN]
03:03:52  1 of 1 OK hook: elementary.on-run-start.0 ...................................... [OK in 0.10s]
03:03:52
03:03:52  1 of 1 START test user_name_is_not_null ........................................ [RUN]
03:03:52  1 of 1 PASS user_name_is_not_null .............................................. [PASS in 0.07s]
03:03:52
03:03:54  1 of 1 START hook: elementary.on-run-end.0 ..................................... [RUN]
03:03:54  1 of 1 OK hook: elementary.on-run-end.0 ........................................ [OK in 1.65s]
03:03:54
03:03:54  Finished running 2 project hooks, 1 test in 0 hours 0 minutes and 2.08 seconds (2.08s).
03:03:54
03:03:54  Completed successfully
03:03:54
03:03:54  Done. PASS=3 WARN=0 ERROR=0 SKIP=0 TOTAL=3
```

## DB との接続テストおよびデバッグ用の情報の表示

```
dbt debug
03:12:50  Running with dbt=1.9.2
03:12:50  dbt version: 1.9.2
03:12:50  python version: 3.11.11
03:12:50  python path: /Users/shun/dbt-practice/application/.venv/bin/python3
03:12:50  os info: macOS-14.6.1-x86_64-i386-64bit
03:12:50  Using profiles dir at /Users/shun/dbt-practice/application
03:12:50  Using profiles.yml file at /Users/shun/dbt-practice/application/profiles.yml
03:12:50  Using dbt_project.yml file at /Users/shun/dbt-practice/application/dbt_project.yml
03:12:50  adapter type: postgres
03:12:50  adapter version: 1.9.0
03:12:51  Configuration:
03:12:51    profiles.yml file [OK found and valid]
03:12:51    dbt_project.yml file [OK found and valid]
03:12:51  Required dependencies:
03:12:51   - git [OK found]

03:12:51  Connection:
03:12:51    host: localhost
03:12:51    port: 5432
03:12:51    user: postgres
03:12:51    database: postgres
03:12:51    schema: dbt_dev
03:12:51    connect_timeout: 10
03:12:51    role: None
03:12:51    search_path: None
03:12:51    keepalives_idle: 0
03:12:51    sslmode: None
03:12:51    sslcert: None
03:12:51    sslkey: None
03:12:51    sslrootcert: None
03:12:51    application_name: dbt
03:12:51    retries: 1
03:12:51  Registered adapter: postgres=1.9.0
03:12:51    Connection test: [OK connection ok]

03:12:51  All checks passed!
```
