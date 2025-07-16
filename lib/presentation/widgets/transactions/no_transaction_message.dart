import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';


class NoTranscationMessage extends StatelessWidget {
  final String messageTitle;
  final String messageDesc;

  const NoTranscationMessage({super.key, required this.messageTitle, required this.messageDesc});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16,),
              FadeIn(
                duration: const Duration(milliseconds: 1500),
                child: Image.asset(
                  "assets/images/sin_transacciones.png",
                  width: 150,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                messageTitle,
                style: titleTextStyle.copyWith(color: colors.primary),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
              messageDesc,
                style: descTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32.0,
              ),
              OutlinedButton.icon(
                  onPressed: () {
                   context.push('/home/0');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Reserva una cancha",
                  ))
            ],
          ),
        ),
      );
    }
}
