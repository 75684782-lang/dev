import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../theme.dart';

class SimuladorEducativoScreen extends StatefulWidget {
  const SimuladorEducativoScreen({super.key});

  @override
  State<SimuladorEducativoScreen> createState() => _SimuladorEducativoScreenState();
}

class _SimuladorEducativoScreenState extends State<SimuladorEducativoScreen> {
  final _montoCtrl = TextEditingController(text: '5000');
  final _plazoCtrl = TextEditingController(text: '12');
  double _cuotaFija = 436.17;
  double _totalIntereses = 1234.04;
  double _totalPagar = 6234.04;
  double _pctCapital = 80.2;
  double _pctInteres = 19.8;

  void _simular() {
    final monto = double.tryParse(_montoCtrl.text) ?? 5000;
    final plazo = int.tryParse(_plazoCtrl.text) ?? 12;
    if (monto <= 0 || plazo <= 0) return;

    const tea = 43.92;
    final tem = math.pow(1 + tea / 100, 1 / 12) - 1;
    final cuota = monto * (tem * math.pow(1 + tem, plazo)) / (math.pow(1 + tem, plazo) - 1);
    final totalPagar = cuota * plazo;
    final totalInteres = totalPagar - monto;

    setState(() {
      _cuotaFija = cuota;
      _totalIntereses = totalInteres;
      _totalPagar = totalPagar;
      _pctCapital = (monto / totalPagar * 100);
      _pctInteres = (totalInteres / totalPagar * 100);
    });
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _plazoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador Educativo'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [IncasurTheme.blanco, IncasurTheme.grisClaro.withAlpha(150)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [IncasurTheme.dorado, Color(0xFFB8860B)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.tune, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Parámetros',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _montoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Monto a simular (S/)',
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _plazoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Plazo en meses',
                        prefixIcon: Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _simular,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calcular Cuota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          shadowColor: IncasurTheme.azulProfundo.withAlpha(120),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: IncasurTheme.azulProfundo.withAlpha(80),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Cuota Fija Mensual', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      'S/ ${_cuotaFija.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Tasa Efectiva Anual: 43.92% (sin seguro de desgravamen)',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [IncasurTheme.amarillo, IncasurTheme.dorado],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Distribución del Pago Total',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: IncasurTheme.azulProfundo),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _DonutChartPainter(_pctCapital, _pctInteres),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _leyenda(IncasurTheme.verdeAndino, 'Capital', '${_pctCapital.toStringAsFixed(1)}%'),
                        _leyenda(IncasurTheme.dorado, 'Intereses', '${_pctInteres.toStringAsFixed(1)}%'),
                      ],
                    ),
                    const Divider(height: 32),
                    _filaResumen('Capital Solicitado', 'S/ ${double.tryParse(_montoCtrl.text)?.toStringAsFixed(2) ?? "0.00"}', IncasurTheme.verdeAndino),
                    const SizedBox(height: 8),
                    _filaResumen('Total Intereses', 'S/ ${_totalIntereses.toStringAsFixed(2)}', IncasurTheme.dorado),
                    const SizedBox(height: 8),
                    _filaResumen('Total a Pagar', 'S/ ${_totalPagar.toStringAsFixed(2)}', IncasurTheme.azulProfundo),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'TEA base: 43.92% (sin seguro de desgravamen)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leyenda(Color color, String label, String valor) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withAlpha(80), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text('$label: $valor', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _filaResumen(String label, String valor, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(valor, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double pctCapital;
  final double pctInteres;
  _DonutChartPainter(this.pctCapital, this.pctInteres);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height / 2 - 20;
    final capitalAngle = 2 * math.pi * pctCapital / 100;
    final interesAngle = 2 * math.pi * pctInteres / 100;

    final capitalPaint = Paint()
      ..color = IncasurTheme.verdeAndino
      ..style = PaintingStyle.fill;
    final interesPaint = Paint()
      ..color = IncasurTheme.dorado
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, radius, shadowPaint);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, capitalAngle, true, capitalPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2 + capitalAngle, interesAngle, true, interesPaint);

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.58, innerPaint);

    canvas.drawCircle(center, radius * 0.58, Paint()
      ..color = Colors.black.withAlpha(10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${pctCapital.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: IncasurTheme.azulProfundo,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
