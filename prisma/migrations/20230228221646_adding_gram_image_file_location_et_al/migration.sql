/*
  Warnings:

  - You are about to drop the column `published` on the `Gram` table. All the data in the column will be lost.
  - Added the required column `userId` to the `Gram` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "GramVid" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "path" TEXT NOT NULL,
    "critStepId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "GramVid_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GramVid_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Gram" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "content" TEXT,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "Gram_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Gram" ("content", "id", "title") SELECT "content", "id", "title" FROM "Gram";
DROP TABLE "Gram";
ALTER TABLE "new_Gram" RENAME TO "Gram";
CREATE UNIQUE INDEX "Gram_userId_key" ON "Gram"("userId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "GramVid_critStepId_key" ON "GramVid"("critStepId");

-- CreateIndex
CREATE UNIQUE INDEX "GramVid_userId_key" ON "GramVid"("userId");
