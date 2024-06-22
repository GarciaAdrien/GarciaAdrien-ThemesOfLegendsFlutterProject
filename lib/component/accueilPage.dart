import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/answerPage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:flutter/widgets.dart';

import '../utils/utils.dart';
import 'modesDeJeuPage.dart';

class AccueilPage extends StatefulWidget {
  final User user;

  const AccueilPage({Key? key, required this.user}) : super(key: key);

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final GameService gameService =
      GameService('https://themes-of-legend-084997a82b0a.herokuapp.com');
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentGameId;

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
          currentRound: 1,
          totalRounds: 0,
          initialMusicId: musicId,
          initialMusicName: musicName,
          initialMusicType: musicType,
          initialMusicDate: musicDate,
        ),
      ),
    );
  }

  void _startNewGame() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModesDeJeuPage(
          user: widget.user,
          currentGameId: currentGameId,
          currentRound: 0,
          totalRounds: 0,
          gameService: gameService,
          email: widget.user.email,
        ),
      ),
    );
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
          // Bouton "Jouer" au milieu de l'écran
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ImageButtonPlay(
                onPressed: _startNewGame,
                imageUrl: ImageAssets.imageButtonPlay,
              ),
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
            ],
          ),
          // Image KDA
        ],
      ),
    );
  }
}

class ImageButtonPlay extends StatefulWidget {
  const ImageButtonPlay({
    Key? key,
    required this.onPressed,
    required this.imageUrl,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String imageUrl;

  @override
  _ImageButtonPlayState createState() => _ImageButtonPlayState();
}

class _ImageButtonPlayState extends State<ImageButtonPlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onPressed,
              child: Image.asset(
                widget.imageUrl,
                width: 250.0,
                height: 250.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
