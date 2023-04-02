-- CreateTable
CREATE TABLE "Jam" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "startTime" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "teamId" INTEGER NOT NULL,
    CONSTRAINT "User_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Team" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "CritiqueStep" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "stage" INTEGER NOT NULL,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "CritiquePrompt" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "critiqueStepId" INTEGER NOT NULL,
    CONSTRAINT "CritiquePrompt_critiqueStepId_fkey" FOREIGN KEY ("critiqueStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CritiqueStepInstance" (
    "teamId" INTEGER NOT NULL,
    "critStepId" INTEGER NOT NULL,
    CONSTRAINT "CritiqueStepInstance_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "CritiqueStepInstance_critStepId_fkey" FOREIGN KEY ("critStepId") REFERENCES "CritiqueStep" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CritVideo" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);

-- CreateIndex
CREATE UNIQUE INDEX "CritiqueStepInstance_teamId_key" ON "CritiqueStepInstance"("teamId");

-- CreateIndex
CREATE UNIQUE INDEX "CritiqueStepInstance_critStepId_key" ON "CritiqueStepInstance"("critStepId");
