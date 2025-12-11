import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
// Importe os serviços para buscar os dados
import '../services/computador_service.dart';
import '../services/nobreak_service.dart';
import '../services/cliente_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variáveis para armazenar as quantidades
  int _qtdComputadores = 0;
  int _qtdNobreaks = 0;
  int _qtdClientes = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  // Função para buscar os dados das APIs
  Future<void> _carregarEstatisticas() async {
    try {
      // Busca todas as listas simultaneamente para ser mais rápido
      final results = await Future.wait([
        ComputadorService.listarComputadores(),
        NobreakService.listarNobreaks(),
        ClienteService.listarClientes(),
      ]);

      if (mounted) {
        setState(() {
          _qtdComputadores = results[0].length; // Lista de Computadores
          _qtdNobreaks = results[1].length;     // Lista de Nobreaks
          _qtdClientes = results[2].length;     // Lista de Clientes
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Erro ao carregar estatísticas: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'P&R Equipamentos',
        showLogo: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header com logo e boas-vindas
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Logo_P&R_Reduzido_Cores.png',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bem-vindo ao Sistema de',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'Gerenciamento de Equipamentos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Botões de ação principal
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Ajusta o aspecto dinamicamente
                      double itemWidth = constraints.maxWidth / 2;
                      double itemHeight = (constraints.maxHeight / 2);
                      double aspectRatio = itemWidth / itemHeight;

                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: aspectRatio * 1.1,
                        children: [
                          _buildMenuCard(
                            context,
                            icon: Icons.add_circle,
                            title: 'Cadastrar',
                            subtitle: 'Novo equipamento',
                            color: AppTheme.primaryGreen,
                            // Atualiza estatísticas ao voltar
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/cadastro-tipo',
                            ).then((_) => _carregarEstatisticas()),
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.list,
                            title: 'Listar',
                            subtitle: 'Ver equipamentos',
                            color: AppTheme.accentGreen,
                            // Atualiza estatísticas ao voltar (caso apague algo)
                            onTap: () => Navigator.pushNamed(
                              context, 
                              '/listagem'
                            ).then((_) => _carregarEstatisticas()),
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.people,
                            title: 'Clientes',
                            subtitle: 'Gerenciar clientes',
                            color: AppTheme.darkGreen,
                            // Atualiza estatísticas ao voltar
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/clientes', // Corrigido para a rota correta de listagem
                            ).then((_) => _carregarEstatisticas()),
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.person,
                            title: 'Usuários',
                            subtitle: 'Gerenciar usuários',
                            color: AppTheme.lightGreen,
                            onTap: () => Navigator.pushNamed(
                              context, 
                              '/usuarios'
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Estatísticas rápidas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator()) 
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            icon: Icons.computer,
                            label: 'Computadores',
                            value: _qtdComputadores.toString(), // Valor dinâmico
                            color: AppTheme.primaryGreen,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          _buildStatItem(
                            icon: Icons.power,
                            label: 'Nobreaks',
                            value: _qtdNobreaks.toString(), // Valor dinâmico
                            color: AppTheme.accentGreen,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          _buildStatItem(
                            icon: Icons.business,
                            label: 'Clientes',
                            value: _qtdClientes.toString(), // Valor dinâmico
                            color: AppTheme.darkGreen,
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}