-- -- 1. clients
-- CREATE TABLE IF NOT EXISTS clients (
--   client_uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--   first_seen  TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- -- 2. videos
-- CREATE TABLE IF NOT EXISTS videos (
--   id                SERIAL PRIMARY KEY,
--   youtube_id        TEXT UNIQUE NOT NULL,
--   url               TEXT NOT NULL,
--   title             TEXT,
--   transcript        TEXT,
--   gemini_json       JSONB,
--   model_version     SMALLINT DEFAULT 1,
--   last_analyzed_at  TIMESTAMPTZ,
--   is_analyzed BOOLEAN DEFAULT FALSE, -- 동일 url로 재분석 요청시,is_analyzed=TRUE면 DB 저장 결과를 바로 반환
--   analyzed_at TIMESTAMPTZ -- analyzed_at으로 데이터 최신성(RAG, LLM 업그레이드 등) 체크 가능.
-- );;

-- -- 3. client_video (N:M)
-- CREATE TABLE IF NOT EXISTS client_video (
--   client_uuid UUID REFERENCES clients(client_uuid) ON DELETE CASCADE,
--   video_id    INT  REFERENCES videos(id)           ON DELETE CASCADE,
--   first_viewed TIMESTAMPTZ DEFAULT NOW(),
--   view_count   INT DEFAULT 1,
--   PRIMARY KEY (client_uuid, video_id)
-- );

-- -- 4. locations (spatial)
-- CREATE TABLE IF NOT EXISTS locations (
--   id        SERIAL PRIMARY KEY,
--   video_id  INT REFERENCES videos(id) ON DELETE CASCADE,
--   name      TEXT NOT NULL,
--   lat       DOUBLE PRECISION NOT NULL,
--   lng       DOUBLE PRECISION NOT NULL,
--   geom      GEOGRAPHY(Point,4326) NOT NULL,
--   at_second DOUBLE PRECISION
-- );

-- -- 4-1. GiST 인덱스: geom 필드에 공간 인덱스 생성으로 빠른 공간 검색 가능(예: 특정 반경 내 장소 찾기 등)
-- CREATE INDEX IF NOT EXISTS idx_locations_geom ON locations USING GIST (geom);

-- -- 외래키(FK) 인덱스 보완
-- CREATE INDEX IF NOT EXISTS idx_client_video_client ON client_video(client_uuid);
-- CREATE INDEX IF NOT EXISTS idx_client_video_video ON client_video(video_id);
-- CREATE INDEX IF NOT EXISTS idx_locations_video ON locations(video_id);
