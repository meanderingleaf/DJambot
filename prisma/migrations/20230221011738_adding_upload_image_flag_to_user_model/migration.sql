-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "critiqueStage" INTEGER NOT NULL DEFAULT 0,
    "settingGoal" BOOLEAN NOT NULL DEFAULT false,
    "uploadingImage" BOOLEAN NOT NULL DEFAULT false,
    "discordThread" TEXT,
    "userId" BIGINT NOT NULL
);
INSERT INTO "new_User" ("critiqueStage", "discordThread", "id", "name", "settingGoal", "userId") SELECT "critiqueStage", "discordThread", "id", "name", "settingGoal", "userId" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_userId_key" ON "User"("userId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
