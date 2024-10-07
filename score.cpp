#include "score.h"
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

ScoreManager::ScoreManager(QObject *parent)
    : QObject(parent)
{
    initializeDatabase();
}

void ScoreManager::initializeDatabase()
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("scores.db");

    if (!db.open()) {
        qWarning() << "Cannot open database:" << db.lastError().text();
        return;
    }

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS scores ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "score INTEGER, "
               "datetime TEXT)");
}

void ScoreManager::saveScore(int score)
{
    QSqlQuery query;
    query.prepare("INSERT INTO scores (score, datetime) VALUES (:score, :datetime)");
    query.bindValue(":score", score);
    query.bindValue(":datetime", QDateTime::currentDateTime().toString());

    if (!query.exec()) {
        qWarning() << "Failed to save score:" << query.lastError().text();
    }
}

QVariantList ScoreManager::fetchTopScores()
{
    QVariantList result;
    QSqlQuery query("SELECT score, datetime FROM scores ORDER BY score DESC LIMIT 5");

    while (query.next()) {
        QVariantMap scoreEntry;
        scoreEntry["score"] = query.value(0).toInt();
        scoreEntry["datetime"] = query.value(1).toString();
        result.append(scoreEntry);
    }

    return result;
}
