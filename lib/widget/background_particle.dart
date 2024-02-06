import 'package:flutter/material.dart';
import 'package:login_page/constant/constants.dart';
import 'package:particles_flutter/particles_flutter.dart';

class BackgroundParticle extends StatelessWidget {
  const BackgroundParticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: CircularParticle(
        height: AppConst.kHeight,
        width: AppConst.kWidth,
        isRandomColor: true,
        awayAnimationCurve: Curves.easeInOut,
        connectDots: false,
        numberOfParticles: 200,
        randColorList: [
          Colors.white.withOpacity(0.4),
          // Color.fromARGB(255, 159, 0, 0),
          // Color.fromARGB(255, 171, 143, 79),
          // Color.fromARGB(255, 16, 138, 0),
          // Color.fromARGB(255, 2, 24, 162)
          const Color.fromARGB(255, 255, 33, 33).withOpacity(0.4),
          const Color.fromARGB(255, 238, 255, 49).withOpacity(0.4),
          const Color.fromARGB(255, 77, 255, 6).withOpacity(0.4),
          const Color.fromARGB(255, 0, 123, 255).withOpacity(0.4)
        ],
        isRandSize: true,
        enableHover: true,
        speedOfParticles: 1,
        maxParticleSize: 8,
      ),
    );
  }
}
