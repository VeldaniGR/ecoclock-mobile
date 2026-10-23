import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreditosScreen extends StatelessWidget {
  const CreditosScreen({super.key});

  String _iconForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'explorador':
        return 'assets/icons/explorador.svg';
      case 'sensor':
        return 'assets/icons/sensor.svg';
      case 'centinela':
        return 'assets/icons/centinela.svg';
      case 'faro':
        return 'assets/icons/faro.svg';
      default:
        return 'assets/icons/sensor.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    // === Datos de ejemplo (sustituye por los tuyos reales) ===
    final String nivelActual = 'Sensor';
    final double progreso = 0.65;
    final String siguienteNivel = 'Centinela';
    final int racha = 4;
    final int semana = 6676;
    final int tareasTotales = 7035;
    final double totalCreditos = 7117.704;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A0A),
      body: SafeArea(
        child: Column(
          children: [
            // ===================== HEADER FIJO =====================
            // Aquí van tus tabs reales si las tienes en esta pantalla
            // Por ahora dejamos espacio
            const SizedBox(height: 8),

            // Total créditos (fijo)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    'Total créditos',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        totalCreditos.toStringAsFixed(3),
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ===================== CONTENIDO SCROLLABLE =====================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Racha + Semana
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            Icons.local_fire_department,
                            'Racha',
                            '$racha d',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            Icons.calendar_today,
                            'Semana',
                            '$semana',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tareas totales
                    _statCard(
                      Icons.check_circle_outline,
                      'Tareas totales',
                      '$tareasTotales',
                      fullWidth: true,
                    ),
                    const SizedBox(height: 20),

                    // Badge del nivel
                    _levelBadge(
                      nivel: nivelActual,
                      iconPath: _iconForLevel(nivelActual),
                      progreso: progreso,
                      siguiente: siguienteNivel,
                      racha: racha,
                    ),
                    const SizedBox(height: 28),

                    // Logros
                    const Text(
                      'Logros',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _logroItem('Primera contribución', true),
                    _logroItem('Semana en activo', false),
                    _logroItem('Dos hábitats', true),

                    const SizedBox(height: 28),

                    // Historial
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Historial reciente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: lógica de actualizar
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 18,
                            color: Color(0xFF7CFF7C),
                          ),
                          label: const Text(
                            'Actualizar',
                            style: TextStyle(color: Color(0xFF7CFF7C)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _historialItem('+12.5', 'Tarea completada', 'hace 2h'),
                    _historialItem('+8.0', 'Bonus racha', 'hace 5h'),
                    _historialItem('+3.2', 'Tarea completada', 'ayer'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value, {bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF122412),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7CFF7C), size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelBadge({
    required String nivel,
    required String iconPath,
    required double progreso,
    required String siguiente,
    required int racha,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF122412),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4A017).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 56,
            height: 56,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nivel,
                  style: const TextStyle(
                    color: Color(0xFFD4A017),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A017)),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Siguiente: $siguiente · Racha $racha d',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logroItem(String titulo, bool desbloqueado) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            desbloqueado ? Icons.eco : Icons.lock_outline,
            color: desbloqueado ? const Color(0xFF7CFF7C) : Colors.white38,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                color: desbloqueado ? Colors.white : Colors.white54,
                fontSize: 15,
              ),
            ),
          ),
          Icon(
            desbloqueado ? Icons.check_circle : Icons.lock,
            color: desbloqueado ? const Color(0xFF7CFF7C) : Colors.white30,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _historialItem(String cantidad, String descripcion, String tiempo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF122412),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            cantidad,
            style: const TextStyle(
              color: Color(0xFF7CFF7C),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(descripcion, style: const TextStyle(color: Colors.white)),
          ),
          Text(
            tiempo,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
