-- CreateTable
CREATE TABLE "CritGroup" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);

-- CreateTable
CREATE TABLE "UsersInCritgroups" (
    "userId" INTEGER NOT NULL,
    "critGroupId" INTEGER NOT NULL,

    PRIMARY KEY ("userId", "critGroupId"),
    CONSTRAINT "UsersInCritgroups_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UsersInCritgroups_critGroupId_fkey" FOREIGN KEY ("critGroupId") REFERENCES "CritGroup" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
