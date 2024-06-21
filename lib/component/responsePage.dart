import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/utils/utils.dart';

class ResponsePage extends StatelessWidget {
  final User user;
  final int score;
  final int combo;
  final String musicToken;
  final String musicType;
  final String musicDate;
  final String userProposition;
  final String correctedName;
  final VoidCallback onNextRound;

  const ResponsePage({
    Key? key,
    required this.score,
    required this.combo,
    required this.musicToken,
    required this.musicType,
    required this.musicDate,
    required this.userProposition,
    required this.correctedName,
    required this.onNextRound,
    required this.user,
  }) : super(key: key);

  Widget _buildComboImage(int combo) {
    if (combo >= 0 && combo <= 5) {
      return Container(
        margin: EdgeInsets.only(
            top: 20,
            left:
                10), // décalages de 100 pixels vers le bas et 30 pixels vers la gauche
        child: Image.asset(
          'assets/images/combos/combo$combo.png',
          width: 120,
          height: 120,
        ),
      );
    }
    return Container(); // Add a default return statement
  }

  @override
  Widget build(BuildContext context) {
    final String musicImagePath = 'assets/images/results/$musicToken.png';

    return Scaffold(
      body: Container(
        color: AppColors.colorNoirHextech,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            key: Key('response_page_stack'), // Clé ajoutée au Stack principal
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFCDFAFA),
                              blurRadius: 5,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.colorTextTitle,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/legendes/" +
                                user.avatarToken +
                                ".png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Proposition:',
                              style: const TextStyle(
                                color: AppColors.colorText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userProposition.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.colorNoirHextech.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.colorTextTitle,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Bonne Réponse', correctedName),
                        _buildInfoRow('Type de la musique', musicType),
                        _buildInfoRow('Date de la musique', musicDate),
                        const SizedBox(height: 16),
                        Center(
                          child: Image.asset(
                            musicImagePath,
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image,
                                  size: 250, color: Colors.red);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: AppColors.colorTextTitle,
                          width: 2,
                        ),
                      ),
                      child: TextButton(
                        onPressed: onNextRound,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.colorTextTitle,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Continuer la partie',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                        color: AppColors.colorText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Combo: $combo',
                      style: const TextStyle(
                        color: AppColors.colorText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildComboImage(combo),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            color: AppColors.colorText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.colorTextTitle,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
