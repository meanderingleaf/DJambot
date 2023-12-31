/*
  Warnings:

  - Added the required column `currentCritStep` to the `Jam` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Jam" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "server" TEXT NOT NULL DEFAULT 'noserver',
    "name" TEXT NOT NULL,
    "startTime" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "currentCritStep" INTEGER NOT NULL
);
INSERT INTO "new_Jam" ("id", "name", "server", "startTime") SELECT "id", "name", "server", "startTime" FROM "Jam";
DROP TABLE "Jam";
ALTER TABLE "new_Jam" RENAME TO "Jam";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
