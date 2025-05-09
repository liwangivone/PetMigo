part of 'pages.dart';

class PetMigoLogo extends StatelessWidget {
  final double size;
  
  const PetMigoLogo({super.key, this.size = 200});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PetMigoLogoPainter(),
    );
  }
}

class _PetMigoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFE8B4A)
      ..style = PaintingStyle.fill;
    
    // Draw the blob shape
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.3, 
      size.width * 0.15, size.height * 0.2
    );
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.1, 
      size.width * 0.4, size.height * 0.1
    );
    path.quadraticBezierTo(
      size.width * 0.6, size.height * 0.1, 
      size.width * 0.7, size.height * 0.2
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3, 
      size.width * 0.85, size.height * 0.5
    );
    path.quadraticBezierTo(
      size.width * 0.9, size.height * 0.7, 
      size.width * 0.7, size.height * 0.8
    );
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.9, 
      size.width * 0.3, size.height * 0.8
    );
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.7, 
      size.width * 0.2, size.height * 0.4
    );
    
    canvas.drawPath(path, paint);
    
    // Add small circles decorations
    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2), 
      size.width * 0.05, 
      paint
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3), 
      size.width * 0.03, 
      paint
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.7), 
      size.width * 0.04, 
      paint
    );
    
    // Draw the text "PET MIGO"
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: size.width * 0.16,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
    
    final textSpan = TextSpan(
      text: "PET",
      style: textStyle,
      children: [
        TextSpan(
          text: "\nMIGO",
          style: textStyle.copyWith(fontSize: size.width * 0.18),
        ),
      ],
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width * 0.6,
    );
    
    textPainter.paint(
      canvas, 
      Offset(
        size.width * 0.37 - textPainter.width / 2, 
        size.height * 0.37 - textPainter.height / 2
      )
    );
    
    // Draw paw prints
    _drawPawPrint(canvas, Offset(size.width * 0.75, size.height * 0.45), size.width * 0.05, paint);
    _drawPawPrint(canvas, Offset(size.width * 0.6, size.height * 0.65), size.width * 0.04, paint);
  }
  
  void _drawPawPrint(Canvas canvas, Offset center, double size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.5);
    
    // Main pad
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size * 1.2,
        height: size * 1.5,
      ),
      paint
    );
    
    // Toe pads
    canvas.drawCircle(
      Offset(center.dx - size * 0.4, center.dy - size * 0.6), 
      size * 0.4, 
      paint
    );
    canvas.drawCircle(
      Offset(center.dx + size * 0.4, center.dy - size * 0.6), 
      size * 0.4, 
      paint
    );
    canvas.drawCircle(
      Offset(center.dx - size * 0.3, center.dy - size * 0.2), 
      size * 0.4, 
      paint
    );
    canvas.drawCircle(
      Offset(center.dx + size * 0.3, center.dy - size * 0.2), 
      size * 0.4, 
      paint
    );
  }
  
  @override
  bool shouldRepaint(_PetMigoLogoPainter oldDelegate) => false;
}

class CustomSplashScreen extends StatefulWidget {
  final Widget child;
  final Duration duration;
  
  const CustomSplashScreen({
    super.key, 
    required this.child, 
    this.duration = const Duration(seconds: 2)
  });
  
  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    
    _controller.forward();
    
    Future.delayed(widget.duration, () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget.child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
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
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const PetMigoLogo(size: 200),
        ),
      ),
    );
  }
}