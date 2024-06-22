import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/answerPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class NombreDeManches extends StatefulWidget {
  final User user;

  const NombreDeManches({Key? key, required this.user}) : super(key: key);

  @override
  _NombreDeManchesState createState() => _NombreDeManchesState();
}

class _NombreDeManchesState extends State<NombreDeManches> {
  int roundToPlay = 5; // Default value
  final GameService gameService =
      GameService('https://themes-of-legend-084997a82b0a.herokuapp.com');
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentGameId;
  int currentRound = 0;
  int totalRounds = 0;

  void _playMusic(String musicId) {
    final filePath = 'song/$musicId.mp3';
    _audioPlayer.play(AssetSource(filePath));
  }

  void _showCountdownAndPlayMusic(
      String musicId, String musicName, String musicType, String musicDate) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnswerPhasePage(
          user: widget.user,
          gameId: currentGameId ?? '',
          currentRound: currentRound,
          totalRounds: totalRounds,
          initialMusicId: musicId,
          initialMusicName: musicName,
          initialMusicType: musicType,
          initialMusicDate: musicDate,
        ),
      ),
    );
  }

  void _startNewGame(int nombreManches) async {
    final GameResponse gameResponse =
        await gameService.createGame(widget.user.uid, nombreManches);
    currentGameId = gameResponse.gameId;
    currentRound = 1;
    totalRounds = nombreManches;

    final PlayRoundResponse? playRoundResponse =
        await gameService.playRound(currentGameId!);
    if (playRoundResponse != null) {
      _showCountdownAndPlayMusic(
        playRoundResponse.token,
        playRoundResponse.name,
        playRoundResponse.type,
        playRoundResponse.date,
      );
    } else {
      print('Aucun ID de musique initial reçu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              ImageAssets.imageBackground,
              fit: BoxFit.cover,
            ),
          ),
          // GIF en haut à droite
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 8.0),
              /*child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  ImageAssets.caitlynGif,
                  fit: BoxFit.cover,
                ),
              ),
              */
            ),
          ),
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with logo and profile image
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8.0,
                      left: 8.0,
                      right: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
              ),
              // Main page content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 200.0, top: 8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'COMBIEN DE MANCHES ?',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () => _startNewGame(5),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(620, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ), // Fond noir
                            foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorTextTitle,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: const BorderSide(
                                  color: AppColors
                                      .colorTextTitle, // Couleur de la bordure extérieure
                                  width:
                                      1, // Épaisseur de la bordure extérieure
                                ),
                              ),
                            ),
                          ),
                          child: const Text(
                            '5 MANCHES',
                            style: TextStyle(
                              fontSize: 22,
                            ), // Taille du texte modifiée
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => _startNewGame(10),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(620, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ), // Fond noir
                            foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorTextTitle,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: const BorderSide(
                                  color: AppColors
                                      .colorTextTitle, // Couleur de la bordure extérieure
                                  width:
                                      1, // Épaisseur de la bordure extérieure
                                ),
                              ),
                            ),
                          ),
                          child: const Text(
                            '10 MANCHES',
                            style: TextStyle(
                              fontSize: 22,
                            ), // Taille du texte modifiée
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => _startNewGame(15),
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(620, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ), // Fond noir
                            foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.colorTextTitle,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: const BorderSide(
                                  color: AppColors
                                      .colorTextTitle, // Couleur de la bordure extérieure
                                  width:
                                      1, // Épaisseur de la bordure extérieure
                                ),
                              ),
                            ),
                          ),
                          child: const Text(
                            '15 MANCHES',
                            style: TextStyle(
                              fontSize: 22,
                            ), // Taille du texte modifiée
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Image KDA
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 300,
              width: 300,
              child: Image.asset(
                ImageAssets.imageKda,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
