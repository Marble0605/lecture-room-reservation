-- ============================================================
-- 講義室予約システム schema.sql（班で1つに統一して共有する）
--   ・主キーは テーブル名_id + AUTO_INCREMENT
--   ・日付は DATE、時刻は TIME、作成日時は DATETIME
--   ・予約⇔時限の多対多は中間テーブル reservation_periods に分解
-- ============================================================

-- 作り直せるように 子→親 の順で削除
DROP TABLE IF EXISTS reservation_periods;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS reservation_statuses;
DROP TABLE IF EXISTS periods;
DROP TABLE IF EXISTS rooms;

-- 講義室（マスタ）
CREATE TABLE rooms (
    room_id   INT         AUTO_INCREMENT PRIMARY KEY,  -- 講義室ID
    room_name VARCHAR(50) NOT NULL,                    -- 講義室名/番号
    building  VARCHAR(50),                             -- 建物
    floor     INT,                                     -- 階
    capacity  INT         NOT NULL                     -- 収容人数
);

-- 時限（マスタ）
CREATE TABLE periods (
    period_id   INT         AUTO_INCREMENT PRIMARY KEY, -- 時限ID
    period_name VARCHAR(20) NOT NULL UNIQUE,            -- 1限〜5限
    start_time  TIME        NOT NULL,                   -- 開始時刻
    end_time    TIME        NOT NULL                    -- 終了時刻
);

-- 予約ステータス（マスタ）
CREATE TABLE reservation_statuses (
    status_id   INT         AUTO_INCREMENT PRIMARY KEY, -- ステータスID
    status_name VARCHAR(20) NOT NULL UNIQUE             -- 予約済/利用済/キャンセル
);

-- 予約（記録テーブル）
CREATE TABLE reservations (
    reservation_id INT          AUTO_INCREMENT PRIMARY KEY,          -- 予約ID
    room_id        INT          NOT NULL,                           -- どの講義室か(FK)
    reserved_date  DATE         NOT NULL,                           -- 予約日
    reserver_name  VARCHAR(50)  NOT NULL,                           -- 予約者名
    student_no     VARCHAR(20)  NOT NULL,                           -- 学籍番号
    status_id      INT          NOT NULL,                           -- 予約状態(FK)
    purpose        VARCHAR(100),                                    -- 利用目的
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 作成日時
    FOREIGN KEY (room_id)   REFERENCES rooms(room_id),
    FOREIGN KEY (status_id) REFERENCES reservation_statuses(status_id)
);

-- 予約コマ（中間テーブル：予約⇔時限の多対多を分解）
CREATE TABLE reservation_periods (
    reservation_id INT NOT NULL,                        -- どの予約に
    period_id      INT NOT NULL,                        -- どの時限を
    PRIMARY KEY (reservation_id, period_id),            -- 複合主キーで重複防止
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id),
    FOREIGN KEY (period_id)      REFERENCES periods(period_id)
);

-- ============================================================
-- 初期データ（親→子 の順で入れる）
-- ============================================================
INSERT INTO rooms (room_name, building, floor, capacity) VALUES
    ('3101', 'さつき', 1, 200),
    ('3102', 'さつき', 1, 60),
    ('3103', 'さつき', 1, 60),
    ('3104', 'さつき', 1, 60),
    ('3201', 'さつき', 2, 60),
    ('3202', 'さつき', 2, 90),
    ('3203', 'さつき', 2, 60),
    ('3204', 'さつき', 2, 30);

INSERT INTO periods (period_name, start_time, end_time) VALUES
    ('1限', '08:50:00', '10:30:00'), 
    ('2限', '10:40:00', '12:20:00'),
    ('3限', '13:10:00', '14:50:00'), 
    ('4限', '15:00:00', '16:40:00'),
    ('5限', '16:50:00', '18:30:00');

INSERT INTO reservation_statuses (status_name) VALUES
    ('予約済'), ('利用済'), ('キャンセル');

INSERT INTO reservations (room_id, reserved_date, reserver_name, student_no, status_id, purpose) VALUES
    (1, '2026-07-10', '陳志遠',   '1244811075', 1, 'ゼミの打ち合わせ'),
    (3, '2026-07-11', '田中太郎', '1244810000', 1, '勉強会');

-- 予約1は1限と2限の連続、予約2は3限
INSERT INTO reservation_periods (reservation_id, period_id) VALUES
    (1, 1),
    (1, 2),
    (2, 3);
