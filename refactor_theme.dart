import 'dart:io';

void main() {
  final directory = Directory('lib');
  
  final colorMap = {
    'primary': 'primary',
    'onPrimary': 'onPrimary',
    'primaryContainer': 'primaryContainer',
    'onPrimaryContainer': 'onPrimaryContainer',
    'secondary': 'secondary',
    'onSecondary': 'onSecondary',
    'tertiary': 'tertiary',
    'onTertiary': 'onTertiary',
    'tertiaryContainer': 'tertiaryContainer',
    'onTertiaryContainer': 'onTertiaryContainer',
    'error': 'error',
    'errorContainer': 'errorContainer',
    'onError': 'onError',
    'onErrorContainer': 'onErrorContainer',
    'surface': 'surface',
    'onSurface': 'onSurface',
    'surfaceVariant': 'surfaceContainerHighest',
    'onSurfaceVariant': 'onSurfaceVariant',
    'outline': 'outline',
    'outlineVariant': 'outlineVariant',
    'surfaceContainerLowest': 'surfaceContainerLowest',
    'surfaceContainerLow': 'surfaceContainerLow',
    'surfaceContainer': 'surfaceContainer',
    'surfaceContainerHigh': 'surfaceContainerHigh',
    'surfaceContainerHighest': 'surfaceContainerHighest',
  };

  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart') && !entity.path.endsWith('theme.dart')) {
      String content = entity.readAsStringSync();
      
      // Replace AppTheme.xyz with Theme.of(context).colorScheme.xyz
      for (final entry in colorMap.entries) {
        content = content.replaceAll('AppTheme.${entry.key}', 'Theme.of(context).colorScheme.${entry.value}');
      }
      
      entity.writeAsStringSync(content);
    }
  }
}
