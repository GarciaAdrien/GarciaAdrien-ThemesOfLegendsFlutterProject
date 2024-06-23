import 'package:flutter/material.dart';

class AnimatedLegend extends StatefulWidget {
  final String imagePath; // Chemin de l'image
  final VoidCallback onTap; // Callback pour gérer le clic sur l'image

  AnimatedLegend({required this.imagePath, required this.onTap});

  @override
  _AnimatedLegendState createState() => _AnimatedLegendState();
}

class _AnimatedLegendState extends State<AnimatedLegend>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {}); // Rebuild pour mettre à jour l'échelle de l'image
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0); // Déclencher l'animation de réaction
    widget.onTap(); // Appeler la fonction onTap fournie à l'extérieur
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _animation,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20.0), // Coins arrondis avec un rayon de 20
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover, // Ajuster l'image pour couvrir la zone
          ),
        ),
      ),
    );
  }
}
