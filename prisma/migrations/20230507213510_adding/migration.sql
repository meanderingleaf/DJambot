/*
  Warnings:

  - Added the required column `userId` to the `CritMessage` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CritMessage" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "time" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sender" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "CritMessage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritMessage" ("id", "message", "sender", "time") SELECT "id", "message", "sender", "time" FROM "CritMessage";
DROP TABLE "CritMessage";
ALTER TABLE "new_CritMessage" RENAME TO "CritMessage";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
