/*
  Warnings:

  - Added the required column `text` to the `CritiquePrompt` table without a default value. This is not possible if the table is not empty.
  - Added the required column `server` to the `Jam` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CritiquePrompt" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "text" TEXT NOT NULL,
    "critiqueStepId" INTEGER NOT NULL,
    CONSTRAINT "CritiquePrompt_critiqueStepId_fkey" FOREIGN KEY ("critiqueStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritiquePrompt" ("critiqueStepId", "id") SELECT "critiqueStepId", "id" FROM "CritiquePrompt";
DROP TABLE "CritiquePrompt";
ALTER TABLE "new_CritiquePrompt" RENAME TO "CritiquePrompt";
CREATE TABLE "new_Jam" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "server" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "startTime" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Jam" ("id", "name", "startTime") SELECT "id", "name", "startTime" FROM "Jam";
DROP TABLE "Jam";
ALTER TABLE "new_Jam" RENAME TO "Jam";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
