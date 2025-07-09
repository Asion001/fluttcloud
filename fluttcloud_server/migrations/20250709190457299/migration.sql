BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shared_link" (
    "id" bigserial PRIMARY KEY,
    "createdBy" bigint NOT NULL,
    "serverPath" text NOT NULL,
    "linkPrefix" text NOT NULL,
    "deleteAfter" timestamp without time zone
);

-- Indexes
CREATE INDEX "shared_link_created_by_idx" ON "shared_link" USING btree ("createdBy");
CREATE UNIQUE INDEX "shared_link_prefix_idx" ON "shared_link" USING btree ("linkPrefix");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "shared_link"
    ADD CONSTRAINT "shared_link_fk_0"
    FOREIGN KEY("createdBy")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR fluttcloud
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('fluttcloud', '20250709190457299', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250709190457299', "timestamp" = now();

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
