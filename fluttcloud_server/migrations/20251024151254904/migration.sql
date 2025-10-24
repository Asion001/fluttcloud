BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_folder_access" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "folderPath" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_folder_access_idx" ON "user_folder_access" USING btree ("userId", "folderPath");


--
-- MIGRATION VERSION FOR fluttcloud
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('fluttcloud', '20251024151254904', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251024151254904', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
