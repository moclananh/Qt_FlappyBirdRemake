#ifndef SCORE_H
#define SCORE_H

#include <QDateTime>
#include <QList>
#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariant>

class ScoreManager : public QObject
{
    Q_OBJECT
public:
    explicit ScoreManager(QObject *parent = nullptr);

    Q_INVOKABLE void saveScore(int score);
    Q_INVOKABLE QVariantList fetchTopScores();

private:
    void initializeDatabase();

    struct ScoreEntry
    {
        int id;
        int score;
        QString datetime;
    };

    QSqlDatabase db;
};

#endif // SCORE_H
