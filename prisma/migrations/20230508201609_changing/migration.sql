-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_CritSummary" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "description" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "critStepId" INTEGER NOT NULL,
    CONSTRAINT "CritSummary_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "CritSummary_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritSummary" ("critStepId", "description", "id", "userId") SELECT "critStepId", "description", "id", "userId" FROM "CritSummary";
DROP TABLE "CritSummary";
ALTER TABLE "new_CritSummary" RENAME TO "CritSummary";
CREATE TABLE "new_CritVideo" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "path" TEXT NOT NULL,
    "critStepId" INTEGER NOT NULL,
    CONSTRAINT "CritVideo_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritVideo" ("critStepId", "id", "path") SELECT "critStepId", "id", "path" FROM "CritVideo";
DROP TABLE "CritVideo";
ALTER TABLE "new_CritVideo" RENAME TO "CritVideo";
CREATE UNIQUE INDEX "CritVideo_critStepId_key" ON "CritVideo"("critStepId");
CREATE TABLE "new_CritiquePrompt" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "text" TEXT NOT NULL,
    "critiqueStepId" INTEGER NOT NULL,
    CONSTRAINT "CritiquePrompt_critiqueStepId_fkey" FOREIGN KEY ("critiqueStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritiquePrompt" ("critiqueStepId", "id", "text") SELECT "critiqueStepId", "id", "text" FROM "CritiquePrompt";
DROP TABLE "CritiquePrompt";
ALTER TABLE "new_CritiquePrompt" RENAME TO "CritiquePrompt";
CREATE TABLE "new_UsersInCritgroups" (
    "userId" INTEGER NOT NULL,
    "critGroupId" INTEGER NOT NULL,

    PRIMARY KEY ("userId", "critGroupId"),
    CONSTRAINT "UsersInCritgroups_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UsersInCritgroups_critGroupId_fkey" FOREIGN KEY ("critGroupId") REFERENCES "CritGroup" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_UsersInCritgroups" ("critGroupId", "userId") SELECT "critGroupId", "userId" FROM "UsersInCritgroups";
DROP TABLE "UsersInCritgroups";
ALTER TABLE "new_UsersInCritgroups" RENAME TO "UsersInCritgroups";
CREATE TABLE "new_GramVid" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "time" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "path" TEXT NOT NULL,
    "critStepId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "GramVid_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "GramVid_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_GramVid" ("critStepId", "id", "path", "time", "userId") SELECT "critStepId", "id", "path", "time", "userId" FROM "GramVid";
DROP TABLE "GramVid";
ALTER TABLE "new_GramVid" RENAME TO "GramVid";
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
INSERT INTO "new_CritMessage" ("critStepId", "gramVidID", "id", "message", "sender", "time", "userId") SELECT "critStepId", "gramVidID", "id", "message", "sender", "time", "userId" FROM "CritMessage";
DROP TABLE "CritMessage";
ALTER TABLE "new_CritMessage" RENAME TO "CritMessage";
CREATE TABLE "new_CritiqueStep" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "order" INTEGER NOT NULL,
    "stage" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "time" DATETIME NOT NULL,
    "jamId" INTEGER NOT NULL,
    CONSTRAINT "CritiqueStep_jamId_fkey" FOREIGN KEY ("jamId") REFERENCES "Jam" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritiqueStep" ("id", "jamId", "name", "order", "stage", "time") SELECT "id", "jamId", "name", "order", "stage", "time" FROM "CritiqueStep";
DROP TABLE "CritiqueStep";
ALTER TABLE "new_CritiqueStep" RENAME TO "CritiqueStep";
CREATE TABLE "new_CritiqueStepInstance" (
    "teamId" INTEGER NOT NULL,
    "critStepId" INTEGER NOT NULL,
    CONSTRAINT "CritiqueStepInstance_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "CritiqueStepInstance_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_CritiqueStepInstance" ("critStepId", "teamId") SELECT "critStepId", "teamId" FROM "CritiqueStepInstance";
DROP TABLE "CritiqueStepInstance";
ALTER TABLE "new_CritiqueStepInstance" RENAME TO "CritiqueStepInstance";
CREATE UNIQUE INDEX "CritiqueStepInstance_teamId_key" ON "CritiqueStepInstance"("teamId");
CREATE UNIQUE INDEX "CritiqueStepInstance_critStepId_key" ON "CritiqueStepInstance"("critStepId");
CREATE TABLE "new_Goal" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "description" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "critStepId" INTEGER NOT NULL,
    CONSTRAINT "Goal_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Goal_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Goal" ("critStepId", "description", "id", "userId") SELECT "critStepId", "description", "id", "userId" FROM "Goal";
DROP TABLE "Goal";
ALTER TABLE "new_Goal" RENAME TO "Goal";
CREATE TABLE "new_Gram" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "content" TEXT,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "Gram_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Gram" ("content", "id", "title", "userId") SELECT "content", "id", "title", "userId" FROM "Gram";
DROP TABLE "Gram";
ALTER TABLE "new_Gram" RENAME TO "Gram";
CREATE UNIQUE INDEX "Gram_userId_key" ON "Gram"("userId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
