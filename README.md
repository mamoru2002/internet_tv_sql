# インターネットTV データベース構築ドキュメント

このドキュメントでは、  
**データベース作成 → テーブル定義 → サンプルデータ投入 → 動作確認 → クエリ実行**  
まで一貫して実行する手順をまとめています。

## はじめに

このリポジトリをクローンまたはダウンロードして、作業ディレクトリに移動してください：

```bash
git clone https://github.com/mamoru2002/internet_tv_sql.git
cd internet_tv_sql
```
> Git を使用しない場合は、GitHub の「Code → Download ZIP」でダウンロードして解凍してください。
---

## 0. 事前準備（前提条件）

1. **MySQL 8.0 以降** がインストールされ、`mysqld` が起動していること  
2. 管理ユーザーでログイン可能であること（`root` または権限を持つ別ユーザー）  

---

## 1. 作業用ユーザーの作成（初回のみ）

```sql
-- MySQL に root などでログインして実行
CREATE USER 'tv_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON internet_tv.* TO 'tv_user'@'localhost';
FLUSH PRIVILEGES;
exit
```

> - DB を一度削除して作り直す場合でも、ユーザーは残るので再実行は不要です。
> - your_passwordは任意のパスワードに置き換えてください

---

## 2. リポジトリ構成

```
internet_tv_sql/
├── schema.sql           # データベース・テーブル定義
├── sample_data.sql      # サンプルデータ INSERT 文
└── queries.sql          # データ取得用クエリ
```

---

## 3. データベース & テーブル作成

```bash
mysql -u tv_user -p < schema.sql
```

---

## 4. サンプルデータ投入

```bash
mysql -u tv_user -p internet_tv < sample_data.sql
```

---

## 5. 動作確認

```bash
mysql -u tv_user -p
> USE internet_tv;
> SHOW TABLES;
> SELECT COUNT(*) FROM channels;
> SELECT * FROM program_slots ORDER BY start_time LIMIT 5;
```

- 以下のように、想定どおりのテーブル一覧・件数・データが取得できれば成功です。

例：

```sql
mysql> SHOW TABLES;
+-----------------------+
| Tables_in_internet_tv |
+-----------------------+
| channels              |
| episodes              |
| genres                |
| program_slots         |
| programs              |
| programs_genres       |
+-----------------------+
6 rows in set (0.001 sec)

mysql> SELECT COUNT(*) FROM channels;
+----------+
| COUNT(*) |
+----------+
|        6 |
+----------+
1 row in set (0.004 sec)

mysql> SELECT * FROM program_slots ORDER BY start_time LIMIT 5;
+----+---------------------+---------------------+------------+------------+-------+
| id | start_time          | end_time            | channel_id | episode_id | views |
+----+---------------------+---------------------+------------+------------+-------+
|  1 | 2025-05-08 10:00:00 | 2025-05-08 10:45:00 |          1 |          1 |  1200 |
|  2 | 2025-05-08 11:00:00 | 2025-05-08 11:50:00 |          1 |          2 |   980 |
|  3 | 2025-05-08 12:00:00 | 2025-05-08 12:24:00 |          3 |          3 |  2100 |
|  4 | 2025-05-08 12:30:00 | 2025-05-08 12:54:00 |          3 |          4 |  1950 |
|  5 | 2025-05-08 13:00:00 | 2025-05-08 13:30:00 |          6 |          5 |   500 |
+----+---------------------+---------------------+------------+------------+-------+
5 rows in set (0.001 sec)
```

---

## 6. データ取得クエリの実行

```bash
mysql -u tv_user -p internet_tv < queries.sql
```

---