/*
  Warnings:

  - Added the required column `jamId` to the `CritiqueStep` table without a default value. This is not possible if the table is not empty.
  - Added the required column `order` to the `CritiqueStep` table without a default value. This is not possible if the table is not empty.
  - Added the required column `time` to the `CritiqueStep` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CritiqueStep" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "order" INTEGER NOT NULL,
    "stage" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "time" DATETIME NOT NULL,
    "jamId" INTEGER NOT NULL,
    CONSTRAINT "CritiqueStep_jamId_fkey" FOREIGN KEY ("jamId") REFERENCES "Jam" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritiqueStep" ("id", "name", "stage") SELECT "id", "name", "stage" FROM "CritiqueStep";
DROP TABLE "CritiqueStep";
ALTER TABLE "new_CritiqueStep" RENAME TO "CritiqueStep";
CREATE UNIQUE INDEX "CritiqueStep_jamId_key" ON "CritiqueStep"("jamId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
