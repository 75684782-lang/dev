import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/solicitud_viewmodel.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(solicitudProvider.notifier).cargarMisSolicitudes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final solVM = ref.watch(solicitudProvider);

    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: [
          _buildHomeTab(auth, solVM),
          _buildCreditosTab(solVM, context),
          _buildPerfilTab(auth, context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        selectedItemColor: IncasurTheme.azulProfundo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card_outlined), label: 'Créditos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(AuthViewModel auth, SolicitudViewModel solVM) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  IncasurTheme.azulProfundo,
                  IncasurTheme.azulOscuro,
                  const Color(0xFF062F3E),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: IncasurTheme.azulProfundo.withAlpha(80),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [IncasurTheme.amarillo, IncasurTheme.dorado],
                                ),
                              ),
                              child: const Icon(Icons.agriculture, size: 22, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'CRAC Incasur',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                onPressed: () => context.push('/notificaciones'),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: () { auth.logout(); context.go('/login'); },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/perfil'),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: IncasurTheme.dorado.withAlpha(120), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: IncasurTheme.dorado.withAlpha(40),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.person, color: IncasurTheme.dorado, size: 30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('¡Bienvenido!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('Cliente CRAC Incasur', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _indicador('Disponible', 'S/ 2,500', IncasurTheme.verdeAndino)),
                        const SizedBox(width: 12),
                        Expanded(child: _indicador('En Curso', 'S/ ${solVM.solicitudes.fold<double>(0, (a, b) => a + b.montoSolicitado).toStringAsFixed(0)}', IncasurTheme.dorado)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [IncasurTheme.amarillo, IncasurTheme.dorado],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('Acciones Rápidas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo)),
                  ],
                ),
                const SizedBox(height: 14),
                _accionRapida(context, Icons.add_circle_outline, 'Nueva Solicitud', '/solicitud', IncasurTheme.verdeAndino),
                _accionRapida(context, Icons.calculate_outlined, 'Simulador Educativo', '/simulador', IncasurTheme.dorado),
                _accionRapida(context, Icons.timeline_outlined, 'Seguimiento', '/seguimiento', IncasurTheme.azulProfundo),
                _accionRapida(context, Icons.calendar_month_outlined, 'Cronograma', '/cronograma', IncasurTheme.azulProfundo),
                _accionRapida(context, Icons.swap_horiz, 'Movimientos', '/movimientos', IncasurTheme.verdeAndino),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditosTab(SolicitudViewModel solVM, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(colors: [IncasurTheme.amarillo, IncasurTheme.dorado]),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Mis Créditos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IncasurTheme.azulProfundo)),
          ],
        ),
        const SizedBox(height: 14),
        if (solVM.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (solVM.solicitudes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.credit_card_off_outlined, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 8),
                const Text('No tienes créditos activos', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        else
          ...solVM.solicitudes.map((c) => _creditoCard(c.numeroExpediente, 'S/ ${c.montoSolicitado.toStringAsFixed(0)}', c.estado, context)),
      ],
    );
  }

  Widget _buildPerfilTab(AuthViewModel auth, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: IncasurTheme.azulProfundo.withAlpha(30),
                child: const Icon(Icons.person, size: 48, color: IncasurTheme.azulProfundo),
              ),
              const SizedBox(height: 12),
              Text('Cliente CRAC Incasur', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ListTile(
          leading: const Icon(Icons.person_outline, color: IncasurTheme.azulProfundo),
          title: const Text('Mi Perfil'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/perfil'),
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined, color: IncasurTheme.azulProfundo),
          title: const Text('Notificaciones'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/notificaciones'),
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz, color: IncasurTheme.azulProfundo),
          title: const Text('Movimientos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/movimientos'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
          onTap: () {
            auth.logout();
            context.go('/login');
          },
        ),
      ],
    );
  }

  Widget _indicador(String label, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(valor, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _creditoCard(String expediente, String monto, String estado, BuildContext context) {
    final color = estado == 'desembolsado' ? IncasurTheme.verdeAndino : IncasurTheme.dorado;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/seguimiento', extra: expediente),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.credit_card, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(expediente, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: IncasurTheme.azulProfundo)),
                      const SizedBox(height: 2),
                      Text('Monto: $monto', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withAlpha(80)),
                  ),
                  child: Text(
                    estado.replaceAll('_', ' '),
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accionRapida(BuildContext context, IconData icon, String label, String route, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: IncasurTheme.azulProfundo)),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
