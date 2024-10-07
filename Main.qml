import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.flappybird.score 1.0
import QtMultimedia

Window {
    width: 288
    height: 511
    visible: true
    title: qsTr("Flappy")

    ScoreManager {
        id: scoreManager
    }

    Rectangle {
        id: game
        property bool initialized: false
        property alias bird: bird

        width: 288
        height: 511

        focus: true

        signal birdPositionChanged
        signal gameOver
        signal destroyPipes

        function terminateGame() {
            initialized = false

            game.gameOver()

            backgroundAnim.stop()
            groundAnim.stop()
            pipeCreator.stop()
            birdRotation.complete()

            gravity.interval = 6

            score.opacity = 0
            backgroundMusic.stop()
            // Save the score when the game terminates
            scoreManager.saveScore(score.count)
            updateScoreList()
            // scoreListView.opacity = 1
        }

        function updateScoreList() {
            var topScores = scoreManager.fetchTopScores()
            scoreListModel.clear() // Clear existing scores

            for (var i = 0; i < topScores.length; i++) {
                scoreListModel.append(topScores[i])
            }
        }

        function increaseScore() {
            score.count++
            scoreDisplay.text = "Score: " + score.count
            // console.log("Jump count: " + score.count)
        }

        function flappy() {
            if (!initialized) {
                initialized = true

                ready.opacity = 0
                score.opacity = 1
                score.count = 0
                scoreDisplay.text = "Score: " + score.count

                gravity.start()
                backgroundAnim.start()
                groundAnim.start()
                pipeCreator.start()
                backgroundMusic.play()
                return
            }

            jumpAnim.from = bird.y
            jumpAnim.to = bird.y - 75
            jumpAnim.start()

            birdRotation.from = bird.rotation
            birdRotation.start()
        }

        Keys.onSpacePressed: {
            game.flappy()
        }
        // Environment handle
        Image {
            id: background
            source: "qrc:/assets/bg2.png"
            width: 288
            height: 500
            fillMode: Image.TileHorizontally

            Timer {
                id: backgroundAnim
                interval: 75
                repeat: true
                running: true

                onTriggered: {
                    background.x -= 1
                    background.width += 1
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    game.flappy()
                    //  flapMusic.play()
                }
            }
        }

        Image {
            id: ground
            source: "qrc:/assets/ground.png"
            width: 288
            height: 112
            y: parent.height - height
            fillMode: Image.TileHorizontally

            Connections {
                target: game

                function onBirdPositionChanged() {
                    if (game.bird.y + game.bird.height >= ground.y) {
                        if (game.initialized)
                            game.terminateGame()
                        gravity.stop()
                        gameOverAnim.start()
                    }
                }
            }

            Timer {
                id: groundAnim
                interval: 12
                repeat: true
                running: true

                onTriggered: {
                    ground.x -= 1
                    ground.width += 1
                }
            }
        }

        // Score handle
        Item {
            id: score
            width: 24
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter
            y: 10
            z: 1
            property int count: 0
        }

        Text {
            id: scoreDisplay
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Score: 0"
            font.pixelSize: 18
            color: "Brown"
            y: 10
            z: 1
        }

        // Hub handle
        Text {
            id: ready
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Get Ready !!"
            font.pixelSize: 35
            color: "Brown"
            y: 60
        }

        Text {
            id: gameOver
            anchors.horizontalCenter: parent.horizontalCenter
            text: "GAME OVER!!!"
            font.pixelSize: 35
            color: "red"
            y: -height
            z: 2

            PropertyAnimation {
                id: gameOverAnim
                target: gameOver
                properties: "y"
                from: -gameOver.height
                to: 70
                duration: 600

                onRunningChanged: {
                    if (!running) {
                        endgameMusic.play()
                        scoreListView.visible = false
                        playAgain.opacity = 1
                        ranking.visible = true
                    }
                }
            }
        }

        //optional button
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: gameOver.bottom
            anchors.topMargin: 10
            spacing: 10
            z: 1
            // Play again button
            Image {
                id: playAgain
                opacity: 0
                height: 54
                width: 100
                source: "qrc:/assets/playagain.png"
                anchors.topMargin: 10

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        endgameMusic.stop()
                        playAgain.opacity = 0
                        gameOver.y = -gameOver.height
                        ready.opacity = 1
                        scoreListView.visible = false
                        ranking.visible = false
                        game.destroyPipes()

                        backgroundAnim.start()
                        groundAnim.start()

                        bird.y = 180
                        bird.rotation = 0

                        //scoreListView.opacity = 0
                        gravity.interval = 9
                    }
                }
            }

            // Ranking button
            Image {
                id: ranking
                height: 54
                width: 100
                visible: false
                source: "qrc:/assets/rankbtn.png"
                anchors.topMargin: 2
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        playAgain.opacity = 1
                        scoreListView.visible = true
                    }
                }
            }
        }

        // Pipe handle
        Timer {
            id: pipeCreator
            interval: 2500
            repeat: true

            onTriggered: {
                var component = Qt.createComponent("Pipe.qml")
                var pipe = component.createObject(game)
                pipe.init()
            }
        }

        // Bird handle
        Image {
            id: bird
            rotation: 0
            source: "qrc:/assets/bird.png"
            width: 34
            height: 24
            x: (parent.width / 2 - width / 2) - 60
            y: 180
            z: 1

            onYChanged: {
                game.birdPositionChanged()
            }
        }

        // Bird animation
        SequentialAnimation {
            id: birdRotation

            property alias from: firstMovement.from

            PropertyAnimation {
                id: firstMovement
                target: bird
                properties: "rotation"
                duration: 50
                to: -50
            }

            PropertyAnimation {
                target: bird
                properties: "rotation"
                duration: 300
                to: 40
            }
        }

        // Bird jump
        PropertyAnimation {
            id: jumpAnim
            easing.type: Easing.OutQuad
            target: bird
            properties: "y"
            duration: 300
        }

        // Gravity
        Timer {
            id: gravity

            repeat: true
            interval: 9

            onTriggered: {
                bird.y += 2
            }
        }
    }
    // Sound effect
    SoundEffect {
        id: backgroundMusic
        source: "qrc:/musics/bgm.wav" // Must be a .wav file
        volume: 0.5
        loops: SoundEffect.Infinite
    }

    SoundEffect {
        id: endgameMusic
        source: "qrc:/musics/endgame.wav"
        volume: 0.5
        loops: 1
    }

    SoundEffect {
        id: flapMusic
        source: "qrc:/musics/birdflap.wav"
        volume: 0.5
        loops: 1
    }

    //list view
    ListView {
        id: scoreListView
        width: parent.width * 0.8
        height: 150
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
        model: scoreListModel
        visible: false
        z: 3
        delegate: Item {
            width: scoreListView.width
            height: 30

            RowLayout {
                anchors.fill: parent
                Text {
                    opacity: 0.7
                    text: "Score: " + score
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    opacity: 0.7
                    text: " Date: " + datetime
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    // ListModel to hold scores
    ListModel {
        id: scoreListModel
    }
}
