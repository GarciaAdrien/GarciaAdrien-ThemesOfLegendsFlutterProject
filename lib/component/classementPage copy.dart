import 'package:flutter/material.dart';
import '../models/models.dart'; // Importez vos modèles
import 'package:blindtestlol_flutter_app/services/highScoreServices.dart';
import '../component/AnimatedPulse.dart';

class ClassementPage extends StatefulWidget {
  final User user;
  const ClassementPage({Key? key, required this.user}) : super(key: key);

  @override
  _ClassementPageState createState() => _ClassementPageState();
}

class _ClassementPageState extends State<ClassementPage> {
  late Future<List<UserHighScore>> futureHighScores;
  int selectedRound = 5; // Tour sélectionné par défaut

  @override
  void initState() {
    super.initState();
    futureHighScores = fetchHighScores(selectedRound);
  }

  Future<List<UserHighScore>> fetchHighScores(int round) async {
    try {
      final highScores = await HighScoreService().getHighScores(round);
      return highScores;
    } catch (e) {
      print('Échec du chargement des meilleurs scores: $e');
      throw Exception('Échec du chargement des meilleurs scores: $e');
    }
  }

  void updateRound(int round) {
    setState(() {
      selectedRound = round;
      futureHighScores = fetchHighScores(selectedRound);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classement Général'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          buildRoundButtons(),
          SizedBox(height: 20),
          Expanded(
            child: buildHighScoreList(),
          ),
        ],
      ),
    );
  }

  Widget buildRoundButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => updateRound(5),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Manche 5',
            style: TextStyle(fontSize: 16), // Augmenter la taille du texte
          ),
        ),
        ElevatedButton(
          onPressed: () => updateRound(10),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Manche 10',
            style: TextStyle(fontSize: 16), // Augmenter la taille du texte
          ),
        ),
        ElevatedButton(
          onPressed: () => updateRound(15),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Manche 15',
            style: TextStyle(fontSize: 16), // Augmenter la taille du texte
          ),
        ),
      ],
    );
  }

  Widget buildHighScoreList() {
    return FutureBuilder<List<UserHighScore>>(
      future: futureHighScores,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun classement trouvé'));
        } else {
          List<UserHighScore> highScores = snapshot.data!;
          return ListView.builder(
            itemCount: highScores.length,
            itemBuilder: (context, index) {
              UserHighScore userHighScore = highScores[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: AnimatedPulse(
                    child: Image.asset(
                      "assets/images/legendes/${userHighScore.userAvatarToken}.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    duration: Duration(milliseconds: 2500), // Custom duration
                  ),
                ),
                title: Text(
                  userHighScore.userName,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score: ${userHighScore.highScore.highScoreValue}',
                      style: TextStyle(
                          fontSize: 14), // Augmenter la taille du texte
                    ),
                    Row(
                      children: [
                        Text('Maîtrise: '),
                        Image.asset(
                          'assets/images/score/${userHighScore.highScore.mastery}.png',
                          width: 50, // Augmenter la largeur de l'image
                          height: 50, // Augmenter la hauteur de l'image
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Aligner à droite
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                                'assets/images/maitriseClassement/${index + 1}.png', // Utilisation de l'index pour construire le chemin d'accès
                                width: 100,
                                height: 100),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
