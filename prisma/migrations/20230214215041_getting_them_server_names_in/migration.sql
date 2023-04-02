-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Jam" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "server" TEXT NOT NULL DEFAULT 'noserver',
    "name" TEXT NOT NULL,
    "startTime" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Jam" ("id", "name", "server", "startTime") SELECT "id", "name", "server", "startTime" FROM "Jam";
DROP TABLE "Jam";
ALTER TABLE "new_Jam" RENAME TO "Jam";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
