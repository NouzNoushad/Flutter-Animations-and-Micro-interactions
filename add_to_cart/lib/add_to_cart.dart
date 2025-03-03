import 'package:flutter/material.dart';

Color backgroundColor = const Color.fromRGBO(37, 129, 97, 1);
Color primaryColor = const Color.fromRGBO(13, 82, 57, 1);

class AddToCartAnimation extends StatefulWidget {
  const AddToCartAnimation({super.key});

  @override
  State<AddToCartAnimation> createState() => _AddToCartAnimationState();
}

class _AddToCartAnimationState extends State<AddToCartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;

  late Animation<double> _slideTopAnimation;
  late Animation<double> _cartSlideMovement;
  late Animation<Offset> _progressOffset1;
  late Animation<Offset> _progressOffset2;
  late Animation<double> _cartUpMovement;

  late bool _showCart;
  late bool _showProgress;
  late bool _showTickIcon;

  initAnimation() {
    _showCart = false;
    _showProgress = false;
    _showTickIcon = false;
    _slideTopAnimation =
        Tween<double>(begin: 0, end: -70).animate(_controller1);
    _cartSlideMovement =
        Tween<double>(begin: -250, end: 10).animate(_controller2);
    _progressOffset1 =
        Tween<Offset>(begin: const Offset(12, 12), end: const Offset(20, -20))
            .animate(_controller3);
    _progressOffset2 =
        Tween<Offset>(begin: const Offset(-40, 12), end: const Offset(-45, -20))
            .animate(_controller3);
    _cartUpMovement = Tween<double>(begin: 0, end: -100).animate(
      _controller4,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 500,
        ));
    _controller2 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 500,
        ));
    _controller3 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 800,
        ));
    _controller4 = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 500,
        ));

    initAnimation();
    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showCart = true;
        _controller2.forward();
      }
    });

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showProgress = true;
        _controller3.forward();
      }
    });

    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showTickIcon = true;

        Future.delayed(const Duration(milliseconds: 500), () {
          _controller4.forward();
          _slideTopAnimation =
              Tween<double>(begin: 70, end: 0).animate(_controller4);
        });
      }
    });
  }

  resetAnimations() {
    _controller1.reset();
    _controller2.reset();
    _controller3.reset();
    _controller4.reset();
    initAnimation();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
          animation: Listenable.merge(
              [_controller1, _controller2, _controller3, _controller4]),
          builder: (context, child) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.width * 0.98,
                    color: Colors.transparent,
                    child: CustomPaint(
                      painter: AddToCartPainter(
                        slideToTop: _slideTopAnimation.value,
                        showCart: _showCart,
                        cartSlideMotion: _cartSlideMovement.value,
                        showProgress: _showProgress,
                        showTickIcon: _showTickIcon,
                        progressOffset1: _progressOffset1.value,
                        progressOffset2: _progressOffset2.value,
                        cartUpMotion: _cartUpMovement.value,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      resetAnimations();
                      _controller1.forward();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.width * 0.98,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class AddToCartPainter extends CustomPainter {
  const AddToCartPainter(
      {required this.slideToTop,
      required this.showCart,
      required this.cartSlideMotion,
      required this.showProgress,
      required this.showTickIcon,
      required this.progressOffset1,
      required this.progressOffset2,
      required this.cartUpMotion});
  final double slideToTop;
  final bool showCart;
  final double cartSlideMotion;
  final bool showProgress;
  final bool showTickIcon;
  final Offset progressOffset1;
  final Offset progressOffset2;
  final double cartUpMotion;

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Offset offset = Offset(w * 0.5, h * 0.5);

    drawText(String text, Offset offset, Color color, double size) {
      TextPainter textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: size, color: color, fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    drawIcon(IconData iconData, Offset offset) {
      IconData icon = iconData;
      TextPainter textPainter = TextPainter(
          textAlign: TextAlign.center, textDirection: TextDirection.rtl);
      textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
              fontSize: 35.0,
              fontFamily: icon.fontFamily,
              color: Colors.white));
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    drawCart(Offset cartOffset) {
      // cart basket
      canvas.drawPath(
          Path()
            ..moveTo(cartOffset.dx - 35, cartOffset.dy + 12)
            ..lineTo(cartOffset.dx + 10, cartOffset.dy + 12)
            ..lineTo(cartOffset.dx + 20, cartOffset.dy - 20)
            ..lineTo(cartOffset.dx - 45, cartOffset.dy - 20)
            ..close(),
          Paint()..color = Colors.white);

      if (showProgress) {
        canvas.drawPath(
            Path()
              ..moveTo(cartOffset.dx - 35, cartOffset.dy + 12)
              ..lineTo(cartOffset.dx + 10, cartOffset.dy + 12)
              ..lineTo(cartOffset.dx + progressOffset1.dx,
                  cartOffset.dy + progressOffset1.dy)
              ..lineTo(cartOffset.dx + progressOffset2.dx,
                  cartOffset.dy + progressOffset2.dy)
              ..close(),
            Paint()..color = backgroundColor);
      }

      // cart handle
      canvas.drawPath(
          Path()
            ..moveTo(cartOffset.dx - 60, cartOffset.dy - 30)
            ..lineTo(cartOffset.dx - 48, cartOffset.dy - 30)
            ..lineTo(cartOffset.dx - 36, cartOffset.dy + 18)
            ..lineTo(cartOffset.dx + 15, cartOffset.dy + 18),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);

      // cart right wheel
      canvas.drawCircle(Offset(cartOffset.dx + 2, cartOffset.dy + 32), 8,
          Paint()..color = Colors.white);
      // cart left wheel
      canvas.drawCircle(Offset(cartOffset.dx - 30, cartOffset.dy + 32), 8,
          Paint()..color = Colors.white);

      // tick icon
      drawTickIcon() {
        canvas.drawPath(
            Path()
              ..moveTo(cartOffset.dx - 22, cartOffset.dy - 2)
              ..lineTo(cartOffset.dx - 15, cartOffset.dy + 5)
              ..lineTo(cartOffset.dx, cartOffset.dy - 10),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 3
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke);
      }

      if (showTickIcon) {
        drawTickIcon();
      }
    }

    canvas.clipRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: offset, width: w, height: h),
        const Radius.circular(60)));
    // background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: offset, width: w, height: h),
            const Radius.circular(60)),
        Paint()..color = primaryColor);

    // draw shopping cart
    Offset cartOffset =
        Offset(offset.dx + cartSlideMotion, offset.dy + cartUpMotion);
    if (showCart) {
      drawCart(cartOffset);
    }

    // add to cart text
    Offset titleOffset = Offset(offset.dx, offset.dy + slideToTop);
    drawText('Add To Cart', Offset(titleOffset.dx - 50, titleOffset.dy - 15),
        Colors.white, 25);

    Offset iconOffset = Offset(titleOffset.dx - 150, titleOffset.dy - 18);
    drawIcon(Icons.add, iconOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
