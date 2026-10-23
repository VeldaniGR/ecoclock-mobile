import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonarScreen extends StatefulWidget {
  const DonarScreen({super.key});

  @override
  State<DonarScreen> createState() => _DonarScreenState();
}

class _DonarScreenState extends State<DonarScreen> {
  double? selectedAmount;

  // TODO: Cuando tengas la cuenta de Stripe, sustituye este enlace
  // por tu Payment Link real o por la llamada a tu backend.
  final String stripePaymentLink = 'https://buy.stripe.com/test_XXXXXXXX'; // <-- CAMBIAR

  final List<double> quickAmounts = [5, 10, 25, 50];

  Future<void> _openStripe() async {
    final uri = Uri.parse(stripePaymentLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace de pago')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apoya Eco\'clock Network',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'El 95 % de tu donación se destina directamente a las ONGs asociadas. '
                'El 5 % restante se utiliza para el mantenimiento y desarrollo de la plataforma.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Elige una cantidad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),

              // Botones de cantidad rápida
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: quickAmounts.map((amount) {
                  final isSelected = selectedAmount == amount;
                  return GestureDetector(
                    onTap: () => setState(() => selectedAmount = amount),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFD4A017)
                            : const Color(0xFF122412),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFD4A017)
                              : Colors.white12,
                        ),
                      ),
                      child: Text(
                        '${amount.toInt()} €',
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Otra cantidad (solo visual por ahora)
              GestureDetector(
                onTap: () {
                  // TODO: abrir diálogo para cantidad personalizada
                  setState(() => selectedAmount = null);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122412),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Center(
                    child: Text(
                      'Otra cantidad',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Botón principal
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _openStripe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35), // naranja como el de "Refrescar"
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Donar ahora',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Disclaimer
              const Text(
                'Serás redirigido a Stripe para completar el pago de forma segura. '
                'Cuando tengamos la cuenta bancaria lista, este enlace se actualizará.',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
