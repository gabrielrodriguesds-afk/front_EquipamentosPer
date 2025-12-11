import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class EquipmentCard extends StatelessWidget {
  final String codigo;
  final String marca;
  final String modelo;
  final String setor;
  final String? operador;
  final String? fotoUrl;
  final String tipo; // 'computador' ou 'nobreak'
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Map<String, dynamic>? extraInfo;

  const EquipmentCard({
    super.key,
    required this.codigo,
    required this.marca,
    required this.modelo,
    required this.setor,
    this.operador,
    this.fotoUrl,
    required this.tipo,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.extraInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com código e tipo
              Row(
                children: [
                  // Ícone do tipo de equipamento
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      tipo == 'computador' ? Icons.computer : Icons.power,
                      color: AppTheme.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Código e tipo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          codigo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          tipo == 'computador' ? 'Computador' : 'Nobreak',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Menu de ações
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: AppTheme.errorColor),
                                SizedBox(width: 8),
                                Text('Excluir', style: TextStyle(color: AppTheme.errorColor)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Informações principais
              Row(
                children: [
                  // Foto (se disponível)
                  if (fotoUrl != null && fotoUrl!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fotoUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  
                  // Informações do equipamento
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.business, 'Marca', marca),
                        const SizedBox(height: 4),
                        _buildInfoRow(Icons.devices, 'Modelo', modelo),
                        const SizedBox(height: 4),
                        _buildInfoRow(Icons.location_on, 'Setor', setor),
                        if (operador != null && operador!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          _buildInfoRow(Icons.person, 'Operador', operador!),
                        ],
                        
                        // Informações extras específicas do tipo
                        if (extraInfo != null) ...[
                          const SizedBox(height: 8),
                          ...extraInfo!.entries.map((entry) {
                            IconData icon = _getIconForKey(entry.key);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: _buildInfoRow(icon, entry.key, entry.value.toString()),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'numero serie':
      case 'numeroSerie':
        return Icons.qr_code;
      case 'data bateria':
      case 'dataBateria':
        return Icons.battery_alert;
      case 'modelo bateria':
      case 'modeloBateria':
        return Icons.battery_std;
      case 'quantidade baterias':
      case 'quantidadeBaterias':
        return Icons.battery_charging_full;
      default:
        return Icons.info;
    }
  }
}

