# 講義室予約システム（データベース演習・班プロジェクト）

学内の講義室を「時限（コマ）」単位で予約するStreamlitアプリのDB設計・実装です。

## 動かし方
1. Docker Desktop を起動し、`docker compose up -d` で MySQL を起動
2. スキーマを流し込む（`docker-compose.yml` のある場所で）
   ```
   Get-Content schema.sql | docker compose exec -T db mysql -ustudent -pstudent sampledb
   ```
3. アプリを起動
   ```
   streamlit run app.py
   ```

## 構成
- `schema.sql` … 班で統一するテーブル定義＋初期データ（**変更したら全員に共有**）
- `db.py` … 共通のDB接続部品
- `app.py` … ホーム画面
- `pages/` … 1人1ファイル＝1機能

## テーブル（ER図に対応）
rooms / periods / reservation_statuses / reservations / reservation_periods（予約⇔時限の多対多を中間テーブルで分解）

## 班の約束
- テーブル名・列名は英小文字＋アンダースコア、主キーは `テーブル名_id`（AUTO_INCREMENT）
- 書き込み後は必ず `conn.commit()`、値は `%s` プレースホルダで渡す
- `schema.sql` は班で1つ。変更は必ず全員へ共有してから

## メンバーと担当
| メンバー | 学籍番号 | 担当機能 |
|---|---|---|
| 陳 志遠 | 1244811075 | （記入） |
|  |  |  |
