import 'package:flutter/material.dart';

import '../models/eintrag_status.dart';
import '../theme/tokens.dart';

/// Statuskreis aus dem Design-Doc (20px): offener Ring / gefüllter Haken /
/// gefüllter Haken mit Uhr-Glyph für "verspätet".
class StatusKreis extends StatelessWidget {
  final EintragStatus status;
  final VoidCallback? onTap;

  const StatusKreis({super.key, required this.status, this.onTap});

  Color get _farbe => switch (status) {
        EintragStatus.offen => AppColors.statusOpen,
        EintragStatus.erledigtPuenktlich => AppColors.statusDoneOnTime,
        EintragStatus.erledigtVerspaetet => AppColors.statusDoneLate,
        EintragStatus.verpasst => AppColors.statusMissed,
      };

  @override
  Widget build(BuildContext context) {
    final istOffen = status == EintragStatus.offen;

    Widget kreis = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: istOffen ? Colors.transparent : _farbe,
        border: istOffen ? Border.all(color: _farbe, width: 1.5) : null,
      ),
      child: istOffen
          ? null
          : Icon(
              Icons.check,
              size: 13,
              color: AppColors.bgBase,
            ),
    );

    if (status == EintragStatus.erledigtVerspaetet) {
      kreis = Stack(
        clipBehavior: Clip.none,
        children: [
          kreis,
          const Positioned(
            right: -3,
            bottom: -3,
            child: Icon(Icons.access_time_filled, size: 11, color: AppColors.statusDoneLate),
          ),
        ],
      );
    }

    if (onTap == null) return kreis;
    return GestureDetector(onTap: onTap, child: kreis);
  }
}
