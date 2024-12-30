import 'package:fluent_ui/fluent_ui.dart';
import 'package:svg_viewer/src/view/home_panel.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({super.key});
  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Text('Appbar'),
      ),
      pane: NavigationPane(
        size: const NavigationPaneSize(openWidth: 150.0),
        selected: selectedIndex,
        onChanged: (index) => setState(() => selectedIndex = index),
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text("Home"),
            body: const HomePanelView()
          ),
          PaneItem(
            icon: const Icon(FluentIcons.favicon),
            title: const Text("Favorites"),
            body: const Text("Favorites")
          ),
        ]
      ),
    );
  }
}