import 'dart:convert';
import 'dart:math';
import 'package:blindtestlol_flutter_app/component/gameOverScreen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/gameServices.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';
import 'package:blindtestlol_flutter_app/component/responsePage.dart';
import 'package:flutter/services.dart';

class AnswerPhasePage extends StatefulWidget {
  final User user;
  final String gameId;
  final int totalRounds;
  final int currentRound;
  final String initialMusicId;
  final String initialMusicName;
  final String initialMusicType;
  final String initialMusicDate;

  const AnswerPhasePage({
    Key? key,
    required this.user,
    required this.gameId,
    required this.totalRounds,
    required this.currentRound,
    required this.initialMusicId,
    required this.initialMusicName,
    required this.initialMusicType,
    required this.initialMusicDate,
  }) : super(key: key);

  @override
  _AnswerPhasePageState createState() => _AnswerPhasePageState();
}

class _AnswerPhasePageState extends State<AnswerPhasePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final GameService gameService =
      GameService('https://themes-of-legend-084997a82b0a.herokuapp.com');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _propositionController = TextEditingController();
  final TextEditingController _typeController =
      TextEditingController(text: "TYPE DE LA MUSIQUE");
  final TextEditingController _dateController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentRound = 1;
  int currentScore = 0;
  int currentCombo = 0;
  late String _randomImagePath = 'assets/images/gif/sticker_1.gif';
  bool showRoundCountdown = false;

  late String _currentMusicToken; // Variable d'état pour stocker le musicToken

  String? correctedName;
  String? correctedType;
  String? correctedDate;
  String? previousMusicId;
  String? previousMusicType;
  String? previousMusicDate;
  String? previousCorrectedName;
  String? previousMusicToken;

  @override
  void initState() {
    super.initState();
    _initRandomImagePath();

    currentRound = widget.currentRound;
    _currentMusicToken = widget.initialMusicId; // Initialisez le token ici
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(
      begin: (currentRound - 1) / widget.totalRounds,
      end: currentRound / widget.totalRounds,
    ).animate(_animationController);
    _typeController.text = "TYPE DE LA MUSIQUE";

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        _showInitialCountdownAndPlayMusic(widget.initialMusicId);
      }
    });
  }

  Future<void> _initRandomImagePath() async {
    final List<String> gifPaths = await _loadGifPaths();
    if (gifPaths.isNotEmpty) {
      final randomImagePath = gifPaths[Random().nextInt(gifPaths.length)];
      setState(() {
        _randomImagePath = randomImagePath;
      });
    } else {
      setState(() {
        _randomImagePath = 'assets/images/gif/sticker_1.gif';
      });
    }
  }

  Future<List<String>> _loadGifPaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    return manifestMap.keys
        .where((String key) => key.contains('assets/images/gif/'))
        .toList();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _animationController.dispose();
    _propositionController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showInitialCountdownAndPlayMusic(String musicId) {
    setState(() {
      showRoundCountdown = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AbsorbPointer(
          absorbing:
              false, // Pour empêcher les interactions avec le contenu derrière
          child: Opacity(
            opacity: 0.0, // Opacité à 0 pour rendre la modale invisible
            child: Dialog(
              child: ScoreComboCountdownWidget(
                seconds: 0,
                onComplete: () {
                  Navigator.of(context).pop();
                  _audioPlayer.play(AssetSource('song/$musicId.mp3'));
                  _startRoundCountdown();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNextCountdownAndPlayMusic(String musicId, int score, int combo) {
    setState(() {
      currentScore = score;
      currentCombo = combo;
      showRoundCountdown = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AbsorbPointer(
          absorbing:
              false, // Pour empêcher les interactions avec le contenu derrière
          child: Opacity(
            opacity: 0.0, // Opacité à 0 pour rendre la modale invisible
            child: Dialog(
              child: ScoreComboCountdownWidget(
                seconds: 0,
                onComplete: () {
                  Navigator.of(context).pop();
                  _audioPlayer.play(AssetSource('song/$musicId.mp3'));
                  _startRoundCountdown();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _startRoundCountdown() {
    setState(() {
      showRoundCountdown = true;
    });
  }

  Future<void> _submitResponse() async {
    if (!_formKey.currentState!.validate()) return;

    await _audioPlayer.stop();

    print('Submitting response for gameId: ${widget.gameId}');
    print('Music ID: $_currentMusicToken'); // Utilisez la variable d'état ici
    print('Proposition: ${_propositionController.text}');
    print('Type: ${_typeController.text}');
    print('Date: ${_dateController.text}');

    try {
      final GameResponse apiResponse = await gameService.postPlayerResponse(
        gameId: widget.gameId,
        musicToken: _currentMusicToken, // Utilisez la variable d'état ici
        proposition: _propositionController.text,
        type: _typeController.text,
        date: _dateController.text,
      );

      print('Received API response: ${apiResponse.toJson()}');

      final String userProposition = _propositionController.text;

      _propositionController.clear();
      _typeController.clear();
      _dateController.clear();

      if (apiResponse.over) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameOverScreen(
              score: apiResponse.player.score,
              mastery: apiResponse.player.mastery,
              user: widget.user,
            ),
          ),
        );
        return;
      }

      final playRoundResponse = await gameService.playRound(widget.gameId);
      print('Play round response: ${playRoundResponse?.toJson()}');

      if (playRoundResponse == null) {
        print('Error: playRoundResponse is null');
        return;
      }

      setState(() {
        currentRound = apiResponse.round + 1;
        currentScore = apiResponse.player.score;
        currentCombo = apiResponse.player.combo;
        _animation = Tween<double>(
          begin: _animation.value,
          end: widget.totalRounds > 0 ? currentRound / widget.totalRounds : 0,
        ).animate(_animationController);
        _animationController.forward(from: 0.0);
        showRoundCountdown = false;

        previousMusicType = apiResponse.musicPlayed.last.type;
        previousMusicDate = apiResponse.musicPlayed.last.date;
        previousCorrectedName = apiResponse.musicPlayed.last.name;
        previousMusicToken = apiResponse.musicPlayed.last.token;

        // Update _currentMusicToken with the token from the playRoundResponse for the next round
        _currentMusicToken = playRoundResponse.token;

        correctedName = playRoundResponse.name;
        correctedType = playRoundResponse.type;
        correctedDate = playRoundResponse.date;

        _initRandomImagePath();
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResponsePage(
            user: widget.user,
            score: apiResponse.player.score,
            combo: apiResponse.player.combo,
            musicToken: previousMusicToken!,
            musicType: previousMusicType!,
            musicDate: previousMusicDate!,
            userProposition: userProposition,
            correctedName: previousCorrectedName!,
            onNextRound: () async {
              Navigator.of(context).pop();
              await Future.delayed(Duration(milliseconds: 300));
              if (playRoundResponse != null) {
                _showNextCountdownAndPlayMusic(playRoundResponse.token,
                    apiResponse.player.score, apiResponse.player.combo);
              }
              _initRandomImagePath();
            },
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onCountdownComplete() {
    _submitResponse();
  }

  Future<void> _deleteGameAndExit() async {
    try {
      await gameService.deleteGame(widget.gameId);
      print('Game successfully deleted');
    } catch (e) {
      print('Error deleting game: $e');
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Nom de la musique : ${widget.initialMusicName}');
    print('Type de la musique : ${widget.initialMusicType}');
    print('Date de la musique : ${widget.initialMusicDate}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorNoirHextech,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _audioPlayer.stop();
            _deleteGameAndExit();
          },
        ),
        title: Image.asset(
          ImageAssets.title,
          width: 150,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: showRoundCountdown
                ? CountdownWidget(
                    seconds: 30,
                    onComplete: _onCountdownComplete,
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: AppColors.colorNoirHextech,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      value: _animation.value,
                      backgroundColor: Colors.grey[800],
                      color: AppColors.colorText,
                      minHeight: 10,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Manche $currentRound sur ${widget.totalRounds}',
                style: const TextStyle(
                  color: AppColors.colorText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Image.asset(
                      _randomImagePath,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _propositionController,
                      style: const TextStyle(color: AppColors.colorText),
                      decoration: InputDecoration(
                        labelText: 'Quel est le nom de cette musique',
                        labelStyle: TextStyle(color: AppColors.colorTextTitle),
                        hintText: 'NOM DE LA MUSIQUE',
                        hintStyle: TextStyle(
                          color: AppColors.colorTextTitle.withOpacity(0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.colorTextTitle),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.colorTextTitle),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _typeController.text.isNotEmpty
                          ? _typeController.text
                          : null,
                      items: [
                        DropdownMenuItem<String>(
                          value: "TYPE DE LA MUSIQUE",
                          child: Text("TYPE DE LA MUSIQUE"),
                        ),
                        DropdownMenuItem<String>(
                          value: "SKIN",
                          child: Text("SKIN"),
                        ),
                        DropdownMenuItem<String>(
                          value: "EVENT",
                          child: Text("EVENT"),
                        ),
                        DropdownMenuItem<String>(
                          value: "CHAMPION",
                          child: Text("CHAMPION"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _typeController.text = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quel est le type de cette musique ?',
                        labelStyle: TextStyle(color: AppColors.colorTextTitle),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.colorTextTitle),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.colorTextTitle),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: _dateController.text.isNotEmpty
                          ? int.tryParse(_dateController.text)
                          : null,
                      items: [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text("DATE DE LA MUSIQUE"),
                        ),
                        ...List.generate(14, (index) => 2010 + index)
                            .map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ],
                      onChanged: (int? newValue) {
                        setState(() {
                          _dateController.text = newValue.toString();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quand est sortie cette musique ?',
                        labelStyle: TextStyle(color: AppColors.colorTextTitle),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.colorTextTitle),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.colorTextTitle),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitResponse,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.colorNoirHextech,
                        backgroundColor: AppColors.colorTextTitle,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: const Text('Envoyer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
