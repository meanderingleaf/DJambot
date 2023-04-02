/*
  Warnings:

  - Added the required column `critStepId` to the `CritVideo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `path` to the `CritVideo` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CritVideo" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "path" TEXT NOT NULL,
    "critStepId" INTEGER NOT NULL,
    CONSTRAINT "CritVideo_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritVideo" ("id") SELECT "id" FROM "CritVideo";
DROP TABLE "CritVideo";
ALTER TABLE "new_CritVideo" RENAME TO "CritVideo";
CREATE UNIQUE INDEX "CritVideo_critStepId_key" ON "CritVideo"("critStepId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
