import 'package:audioplayers/audioplayers.dart';
import 'package:blindtestlol_flutter_app/component/AnimatedLegend.dart';
import 'package:flutter/material.dart';
import 'package:blindtestlol_flutter_app/component/homePage.dart';
import 'package:blindtestlol_flutter_app/models/models.dart';
import 'package:blindtestlol_flutter_app/services/userServices.dart';
import '../utils/utils.dart';

class BoutiquePage extends StatefulWidget {
  final User user;
  final Function(User) updateUser;

  const BoutiquePage({required this.user, required this.updateUser});

  @override
  _BoutiquePageState createState() => _BoutiquePageState();
}

class _BoutiquePageState extends State<BoutiquePage> {
  late List<Avatar> avatars = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _audioPlayer.play(AssetSource('musicBackground/boutique.mp3'));
    _loadAvatars();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  Future<void> _loadAvatars() async {
    try {
      List<Avatar> fetchedAvatars =
          await UserService().getAllAvatars(widget.user.uid, false);

      setState(() {
        avatars = fetchedAvatars;
      });
    } catch (e) {
      print('Failed to load avatars: $e');
    }
  }

  Future<void> _handleBuyAvatar(
      String imageName, int avatarId, int avatarPrice) async {
    try {
      User updatedUser = await UserService().getUser(widget.user.uid);
      // Check if user has enough points
      if (updatedUser.totalScore < avatarPrice) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Vous n\'avez pas assez de points pour acheter cet avatar.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Proceed with the purchase
      await UserService().buyAvatar(
        widget.user.uid,
        avatarId,
      );

      // Update the user's score

      if (!mounted) return;
      widget.updateUser(updatedUser);

      // Redirect to the home page with updated user info
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: updatedUser,
            updateUser: widget.updateUser,
          ),
        ),
      );

      _audioPlayer.stop();
    } catch (e) {
      // Handle errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'achat de $imageName : $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            AppBar(
              title: Text('Boutique'),
              backgroundColor: AppColors.colorNoirHextech,
              foregroundColor: AppColors.colorTextTitle,
            ),
            Positioned(
              top: 20,
              right: 16,
              child: Row(
                children: [
                  Text(
                    'Points: ${widget.user.totalScore}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    ImageAssets.imageEssenceBleue,
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              return _buildGridItem(context, index, avatars[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, Avatar avatar) {
    String imagePath = 'assets/images/legendes/${avatar.token}.png';

    return GestureDetector(
      onTap: () async {
        bool confirmed = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomConfirmDialog(avatar: avatar);
              },
            ) ??
            false;

        if (confirmed) {
          _handleBuyAvatar(avatar.token, avatar.id, avatar.price);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorNoirHextech,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.colorNoirHextech,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedLegend(
                      // Ajout de AnimatedLegend ici
                      imagePath: imagePath,
                      onTap: () {}, // Définir l'action onTap si nécessaire
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              ImageAssets.imageShop,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${avatar.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              ImageAssets.imageEssenceBleue,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.colorNoirHextech,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                avatar.token,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'CustomFont2',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomConfirmDialog extends StatelessWidget {
  final Avatar avatar;

  const CustomConfirmDialog({required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: AppColors.colorNoirHextech,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirmation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Êtes-vous sûr de vouloir acheter ${avatar.token} ?',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final AudioPlayer _audioPlayer = AudioPlayer();
                    _audioPlayer.play(AssetSource('sounds/sfx_buy.mp3'));
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Confirmer',
                    style: TextStyle(
                      color: AppColors.colorTextTitle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
