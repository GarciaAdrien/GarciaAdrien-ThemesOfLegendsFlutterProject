import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/answerPage.dart';
import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'accueilPage.dart';

// ignore: must_be_immutable
class ModesDeJeuPage extends StatefulWidget {
  final User user;
  String? currentGameId;
  int currentRound;
  int totalRounds;
  GameService gameService;

  ModesDeJeuPage({
    Key? key,
    required this.user,
    this.currentGameId,
    this.currentRound = 0,
    this.totalRounds = 0,
    required this.gameService,
    required email,
  }) : super(key: key);

  @override
  _ModesDeJeuPageState createState() => _ModesDeJeuPageState();
}

// Assuming you have already imported AudioPlayer and AssetSource correctly

class _ModesDeJeuPageState extends State<ModesDeJeuPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  static const String jeu1 = ImageAssets.jeu1;
  static const String jeu2 = ImageAssets.jeu2;
  static const String jeu3 = ImageAssets.jeu3;
  static const String jeu4 = ImageAssets.jeu4;

  static const String imageBackground1 = ImageAssets.imageBackground1;
  static const String imageBackground2 = ImageAssets.imageBackground2;
  static const String imageBackground3 = ImageAssets.imageBackground3;
  static const String imageBackground4 = ImageAssets.imageBackground4;

  final List<Map<String, String>> modes = [
    {
      'image': jeu1,
      'title': 'Faille de l\'invocateur',
      'background': imageBackground1,
      'description': 'Jouer en mode Faille de l\'invocateur classique.'
    },
    {
      'image': jeu2,
      'title': 'ARAM',
      'background': imageBackground2,
      'description': 'Mettez vos réflexes musicaux à l\'épreuve en mode ARAM.'
    },
    {
      'image': jeu3,
      'title': 'URF',
      'background': imageBackground3,
      'description': 'Vibrez au rythme des musiques endiablées en mode URF.'
    },
    {
      'image': jeu4,
      'title': 'À Venir',
      'background': imageBackground4,
      'description':
          'Restez à l\'écoute pour découvrir de nouveaux modes de jeu très prochainement !'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modes de Jeu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8),
              ...modes.asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        int roundToPlay;
                        switch (index) {
                          case 0:
                            roundToPlay = 5;
                            break;
                          case 1:
                            roundToPlay = 10;
                            break;
                          case 2:
                            roundToPlay = 15;
                            break;
                          default:
                            roundToPlay = 0;
                            break;
                        }

                        switch (index) {
                          case 0:
                            _playSound('sounds/vfxjinx.mp3');
                            break;
                          case 1:
                            _playSound('sounds/vfxjinx2.mp3');
                            break;
                          case 2:
                            _playSound('sounds/vfxjinx3.mp3');
                            break;
                          default:
                            break;
                        }

                        if (roundToPlay > 0) {
                          _startNewGame(roundToPlay);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                user: widget.user,
                                updateUser: (User) {},
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: AppColors.colorNoirHextech,
                          image: DecorationImage(
                            image: AssetImage(mode['background']!),
                            fit: BoxFit.fill,
                          ),
                        ),
                        height: 150,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: _animation.value,
                              child: Image.asset(
                                mode['image']!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          mode['title']!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'CustomFont1',
                                            color: AppColors.colorText,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          mode['description']!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index != modes.length - 1) SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _playSound(String assetPath) {
    _audioPlayer.play(AssetSource(assetPath));
  }

  void _startNewGame(int roundToPlay) async {
    final GameResponse gameResponse = await widget.gameService.createGame(
      widget.user.uid,
      roundToPlay,
    );
    widget.currentGameId = gameResponse.gameId;
    widget.currentRound = 1;
    widget.totalRounds = roundToPlay;

    final PlayRoundResponse? playRoundResponse =
        await widget.gameService.playRound(widget.currentGameId!);
    if (playRoundResponse != null) {
      _showCountdownAndPlayMusic(
        playRoundResponse.token,
        playRoundResponse.name,
        playRoundResponse.type,
        playRoundResponse.date,
      );
    } else {
      print('No initialMusicId received.');
    }
  }

  void _showCountdownAndPlayMusic(
      String musicId, String musicName, String musicType, String musicDate) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnswerPhasePage(
          user: widget.user,
          gameId: widget.currentGameId ?? '',
          currentRound: widget.currentRound,
          totalRounds: widget.totalRounds,
          initialMusicId: musicId,
          initialMusicName: musicName,
          initialMusicType: musicType,
          initialMusicDate: musicDate,
        ),
      ),
    );
  }
}
