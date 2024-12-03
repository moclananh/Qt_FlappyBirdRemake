#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSoundEffect>
#include "QQuickStyle"
#include "score.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Universal"); // Fusion || Imagine || Material || Universal || Windows
    QQmlApplicationEngine engine;
    qmlRegisterType<ScoreManager>("com.flappybird.score", 1, 0, "ScoreManager");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("QT_Project_FlappyBird", "Main");

    return app.exec();
}
