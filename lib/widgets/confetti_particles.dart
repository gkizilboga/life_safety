import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiParticles extends StatefulWidget {
  final Widget child;
  const ConfettiParticles({super.key, required this.child});

  @override
  State<ConfettiParticles> createState() => _ConfettiParticlesState();
}

class _ConfettiParticlesState extends State<ConfettiParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        _updateParticles();
      });

    // Create initial particles
    _initParticles();
    _controller.repeat();
  }

  void _initParticles() {
    for (int i = 0; i < 100; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * 400, // Will be updated on first layout
        y: -_random.nextDouble() * 800,
        size: _random.nextDouble() * 8 + 4,
        color: _getRandomColor(),
        vx: _random.nextDouble() * 4 - 2,
        vy: _random.nextDouble() * 5 + 2,
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: _random.nextDouble() * 0.2 - 0.1,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      const Color(0xFFFFD700), // Gold
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _updateParticles() {
    setState(() {
      for (var p in _particles) {
        p.y += p.vy;
        p.x += p.vx;
        p.rotation += p.rotationSpeed;
        
        // Reset particle if it goes off screen (approximate height)
        if (p.y > 1000) {
          p.y = -20;
          p.x = _random.nextDouble() * 500;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: CustomPaint(
            painter: ConfettiPainter(_particles),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

class Particle {
  double x, y, size, vx, vy, rotation, rotationSpeed;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<Particle> particles;
  ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    for (var p in particles) {
      final paint = Paint()..color = p.color;
      
      canvas.save();
      canvas.translate(p.x % size.width, p.y);
      canvas.rotate(p.rotation);
      
      // Draw rectangular confetti piece
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
