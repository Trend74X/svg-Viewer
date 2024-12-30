import 'package:fluent_ui/fluent_ui.dart';
import 'package:svg_viewer/src/view/navigation_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: 'Svg Viewer',
      home: NavigationPanel(),
      themeMode: ThemeMode.system
    );
  }
}