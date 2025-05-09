-- 1.よく見られているエピソードを知りたいです。エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください
SELECT
    episodes.name,
    SUM(program_slots.views) AS total_views
FROM
    episodes
    JOIN program_slots ON program_slots.episode_id = episodes.id
GROUP BY
    episodes.id
ORDER BY
    total_views DESC
LIMIT 3;

-- 2.よく見られているエピソードの番組情報やシーズン情報も合わせて知りたいです。エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください
SELECT
    programs.name AS program_name,
    IFNULL(episodes.season_num, '単発') AS season_num,
    IFNULL(episodes.episode_num, '単発') AS episode_num,
    episodes.name AS episode_name,
    SUM(program_slots.views) AS total_views
FROM
    programs
    JOIN episodes ON episodes.program_id = programs.id
    JOIN program_slots ON program_slots.episode_id = episodes.id
GROUP BY
    episodes.id
ORDER BY
    total_views DESC
LIMIT 3;

-- 3.本日の番組表を表示するために、本日、どのチャンネルの、何時から、何の番組が放送されるのかを知りたいです。本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。なお、番組の開始時刻が本日のものを本日放送される番組とみなすものとします
SELECT
    channels.name AS channel_name,
    program_slots.start_time,
    program_slots.end_time,
    IFNULL(episodes.season_num, '単発') AS season_num,
    IFNULL(episodes.episode_num, '単発') AS episode_num,
    episodes.name AS episode_name,
    episodes.episode_detail
FROM
    episodes
    JOIN program_slots ON program_slots.episode_id = episodes.id
    JOIN channels ON program_slots.channel_id = channels.id
WHERE
    DATE(program_slots.start_time) = CURDATE()
ORDER BY
    program_slots.start_time ASC;

-- 4.ドラマというチャンネルがあったとして、ドラマのチャンネルの番組表を表示するために、本日から一週間分、何日の何時から何の番組が放送されるのかを知りたいです。ドラマのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得してください
SELECT
    program_slots.start_time,
    program_slots.end_time,
    IFNULL(episodes.season_num, '単発') AS season_num,
    IFNULL(episodes.episode_num, '単発') AS episode_num,
    episodes.name AS episode_name,
    episodes.episode_detail
FROM
    episodes
    JOIN program_slots ON program_slots.episode_id = episodes.id
    JOIN channels ON program_slots.channel_id = channels.id
WHERE
    channels.name LIKE 'ドラマ%'
    AND DATE(program_slots.start_time) BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY
ORDER BY
    program_slots.start_time ASC;

-- 5.直近一週間で最も見られた番組が知りたいです。直近一週間に放送された番組の中で、エピソード視聴数合計トップ2の番組に対して、番組タイトル、視聴数を取得してください
SELECT
    programs.name,
    SUM(program_slots.views) AS total_views
FROM
    programs
    JOIN episodes ON episodes.program_id = programs.id
    JOIN program_slots ON program_slots.episode_id = episodes.id
WHERE
    DATE(program_slots.start_time) BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE()
GROUP BY
    programs.id
ORDER BY
    total_views DESC
LIMIT 2;

-- 6.ジャンルごとの番組の視聴数ランキングを知りたいです。番組の視聴数ランキングはエピソードの平均視聴数ランキングとします。ジャンルごとに視聴数トップの番組に対して、ジャンル名、番組タイトル、エピソード平均視聴数を取得してください。
SELECT
    genre_name,
    program_name,
    avg_views
FROM(
    SELECT
        genres.name AS genre_name,
        programs.name AS program_name,
        AVG(program_slots.views) AS avg_views,
        ROW_NUMBER() OVER (PARTITION BY genres.name ORDER BY AVG(program_slots.views)) AS avg_rank
    FROM programs
    JOIN episodes ON episodes.program_id = programs.id
    JOIN program_slots ON program_slots.episode_id = episodes.id
    JOIN programs_genres ON programs_genres.program_id = programs.id
    JOIN genres ON programs_genres.genre_id = genres.id
    GROUP BY
        genre_name, program_name) AS ranked 
WHERE
    avg_rank = 1;
