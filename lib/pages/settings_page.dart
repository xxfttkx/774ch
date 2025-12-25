import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          themeColorCard(
            context: context,
            settingsViewModel: settingsViewModel,
          ),
          const SizedBox(height: 16),
          _SettingsCard(
            title: "General Settings",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fontSizeFactorSlider(
                  context: context,
                  fontSizeFactor: settingsViewModel.fontSizeFactor,
                  onChanged: (val) => settingsViewModel.setFontSizeFactor(val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

Widget themeColorCard({
  required BuildContext context,
  required SettingsViewModel settingsViewModel,
}) {
  return _SettingsCard(
    title: "Theme Color",
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(SettingsViewModel.presetColors.length, (i) {
        final color = SettingsViewModel.presetColors[i];
        final isSelected = color == settingsViewModel.color;

        return GestureDetector(
          onTap: () => settingsViewModel.setColorIndex(i),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 3,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }),
    ),
  );
}

Widget fontSizeFactorSlider({
  required BuildContext context,
  required double fontSizeFactor,
  required ValueChanged<double> onChanged,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text("Font Size Factor"),
    subtitle: Slider(
      min: 0.5,
      max: 3.0,
      divisions: 25,
      value: fontSizeFactor,
      label: fontSizeFactor.toStringAsFixed(2),
      onChanged: (value) {
        // fontSizeFactor = value;
      },
      onChangeEnd: (value) {
        onChanged(value); // 通知外部值改变
      },
    ),
    trailing: Text(
      fontSizeFactor.toStringAsFixed(2),
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}
