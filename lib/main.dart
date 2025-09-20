import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/cadastro_tipo_screen.dart';
import 'test_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P&R Equipamentos',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/cadastro-tipo': (context) => const CadastroTipoScreen(),
        '/test-api': (context) => TestApiScreen(),
      },
    );
  }
}

// Tela inicial atualizada com botão de teste da API
class HomeScreenWithTest extends StatelessWidget {
  const HomeScreenWithTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF8BC34A),
              Color(0xFFCDDC39),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/Logo_P&R_Reduzido_Cores.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Título
                Text(
                  'P&R Equipamentos',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 8),
                
                Text(
                  'Gestão de Equipamentos de TI',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                
                SizedBox(height: 48),
                
                // Botões
                Column(
                  children: [
                    _buildMenuButton(
                      context,
                      'Cadastrar',
                      Icons.add_circle_outline,
                      () => Navigator.pushNamed(context, '/cadastro-tipo'),
                    ),
                    
                    SizedBox(height: 16),
                    
                    _buildMenuButton(
                      context,
                      'Listar',
                      Icons.list_alt,
                      () {
                        // TODO: Implementar tela de listagem
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Funcionalidade em desenvolvimento')),
                        );
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    _buildMenuButton(
                      context,
                      'Testar API',
                      Icons.api,
                      () => Navigator.pushNamed(context, '/test-api'),
                      color: Colors.orange,
                    ),
                  ],
                ),
                
                SizedBox(height: 32),
                
                // Versão
                Text(
                  'Versão 1.0.0 - MySQL + Flask',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.white,
          foregroundColor: color != null ? Colors.white : Color(0xFF4CAF50),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

