
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';

class SuccessScreen extends ConsumerStatefulWidget {
  static String get routeName => 'success';
  static String get routeLocation => '/$routeName';
  final String id;
  const SuccessScreen({super.key, required this.id});

  @override
  SuccessScreenState createState() => SuccessScreenState();
}

class SuccessScreenState extends ConsumerState<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                FadeIn(
                  duration: const Duration(milliseconds:1500),
                  child: Text(
                          'Reserva confirmada',
                          style: greetingTextStyle,
                       ),
                ),
                _AnimacionPelota(size: size),
                
                SizedBox(
                 height: size.height / 2.8,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 75,
                        left: size.width/2 - 40,
                        child: FadeIn(
                          delay: const Duration(milliseconds: 2000),
                          curve: Curves.easeOutCubic,
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset('assets/images/start_success_1.png', height: 30, width: 30,))
                          ),
                      Positioned(
                        bottom: 85,
                        left: size.width/2 - 5 ,
                        child: FadeIn(
                          delay: const Duration(milliseconds: 2300),
                          duration: const Duration(milliseconds: 300),
                          child: Transform.rotate(
                            angle: 180,
                            child: Image.asset('assets/images/start_success_1.png', height: 30, width: 30,)))
                          ),
                        Positioned(
                        bottom: 65,
                        left: size.width/2 + 25,
                        child: FadeIn(
                          delay: const Duration(milliseconds: 2600),
                          duration: const Duration(milliseconds: 300),
                          child: Transform.rotate(
                            angle: 70.0,
                            child: Image.asset('assets/images/start_success_1.png', height: 25, width: 25,)))
                          ),
                          
                    ],
                  ),
                ),
                const Spacer(),
                FilledButton.icon(onPressed: (){
                    context.pushReplacement('/home/0');
                }, 
                icon: const Icon(Icons.arrow_back_ios_new_rounded), 
                label: const Text('Volver al Inicio')
                ),
                const SizedBox(height: 10,),
                FilledButton.icon(onPressed: (){
                    context.pushReplacement('/reservations-confirm/${widget.id}');
                }, 
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                icon: const Icon(Icons.arrow_forward_ios_rounded), 
                label: const Text('Ver reserva')
                ),
                const SizedBox(height: 15,),
              ],
            )
          ),
        ]
      ),
    );


  }
}


class _AnimacionPelota extends ConsumerStatefulWidget {
  final Size size;

  const _AnimacionPelota({required this.size});

  @override
  AnimacionPelotaState createState() => AnimacionPelotaState();
}

class AnimacionPelotaState extends ConsumerState<_AnimacionPelota> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> rotacion;
  
  late Animation<double> opacidad;

  late Animation<double> moverAbajo;
  late Animation<double> agrandar;
  

  @override
  void initState() {

    int idUsuario =  ref.read(loginProvider.notifier).retornarIdUsuario();
    ref.read(reservaProvider.notifier).listarReservasPorUsuario(idUsuario);

    double posicion = widget.size.height /2.8;
    controller = AnimationController(
      vsync: this, duration: const Duration( milliseconds: 2600 )
    );

    rotacion = Tween( begin: 0.0, end: 6 * pi  ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut )
    );

    opacidad = Tween( begin: 0.0, end: 1.0 ).animate(
      CurvedAnimation(parent: controller, curve: const Interval( 0, 0.25, curve: Curves.easeOut ) )
    );

    moverAbajo
     = Tween(begin: 0.0, end: posicion ).animate(
      CurvedAnimation(parent: controller, curve: Curves.bounceOut )
    );

    agrandar = Tween(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut )
    );


    controller.addListener(() { 

      // print('Status: ${ controller.status }');
      if ( controller.status == AnimationStatus.completed ) {
        // controller.repeat();
        // controller.reverse();
        //controller.reset();
      }

    });
    
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Play / Reproducción
    controller.forward();

    return AnimatedBuilder(
      animation: controller,
      child: Image.asset(
        'assets/images/success_ball.png', 
        height: 80, 
        width: 80,
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset( 0 , moverAbajo.value),
          child: Transform.rotate(
            angle: rotacion.value,
            child: Opacity(
              opacity: opacidad.value,
              child: child
            )
          ),
        );
      },
    );
   
  }


}



class _Header extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const CustomPaint(
                painter: CustomToolbarShape(lineColor: Colors.green),
              )),
          
          ]
        ));
  }
}
