/*
  Warnings:

  - You are about to drop the column `grameVidID` on the `CritMessage` table. All the data in the column will be lost.
  - Added the required column `gramVidID` to the `CritMessage` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CritMessage" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "time" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sender" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "gramVidID" INTEGER NOT NULL,
    "critStepId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "CritMessage_gramVidID_fkey" FOREIGN KEY ("gramVidID") REFERENCES "GramVid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "CritMessage_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "CritMessage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritMessage" ("critStepId", "id", "message", "sender", "time", "userId") SELECT "critStepId", "id", "message", "sender", "time", "userId" FROM "CritMessage";
DROP TABLE "CritMessage";
ALTER TABLE "new_CritMessage" RENAME TO "CritMessage";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
