import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../viewmodel/solicitud_viewmodel.dart';

class CronogramaScreen extends ConsumerStatefulWidget {
  const CronogramaScreen({super.key});

  @override
  ConsumerState<CronogramaScreen> createState() => _CronogramaScreenState();
}

class _CronogramaScreenState extends ConsumerState<CronogramaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(solicitudProvider.notifier).cargarCronograma('EXP-2026-0001');
    });
  }

  @override
  Widget build(BuildContext context) {
    final solVM = ref.watch(solicitudProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronograma de Pagos'),
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
        child: solVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : solVM.cronograma.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_view_month, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('No hay cronograma disponible', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: IncasurTheme.azulProfundo.withAlpha(60),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Monto', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Capital', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Interés', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Saldo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: solVM.cronograma.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final c = solVM.cronograma[index];
                            final isEven = index % 2 == 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isEven ? Colors.white : IncasurTheme.azulProfundo.withAlpha(8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isEven ? Colors.grey.withAlpha(25) : IncasurTheme.azulProfundo.withAlpha(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(8),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [IncasurTheme.azulProfundo, IncasurTheme.azulOscuro],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${c['cuota']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('S/ ${(c['monto'] as num).toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: IncasurTheme.azulProfundo)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('S/ ${(c['capital'] as num).toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 13, color: IncasurTheme.verdeAndino)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('S/ ${(c['interes'] as num).toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 13, color: IncasurTheme.dorado)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('S/ ${(c['saldo'] as num).toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: IncasurTheme.azulProfundo)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
