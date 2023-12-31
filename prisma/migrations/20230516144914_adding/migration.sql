-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_GramVid" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "time" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "path" TEXT NOT NULL,
    "gramPath" TEXT NOT NULL DEFAULT '-',
    "critStepId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "GramVid_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GramVid_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_GramVid" ("critStepId", "id", "path", "time", "userId") SELECT "critStepId", "id", "path", "time", "userId" FROM "GramVid";
DROP TABLE "GramVid";
ALTER TABLE "new_GramVid" RENAME TO "GramVid";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
