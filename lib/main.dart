import 'package:flutter/material.dart';

void main() => runApp(const BooApp());

class BooApp extends StatelessWidget {
  const BooApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFFFF6A00)),
      home: const PageEntrance(),
    );
  }
}

/* --------- Page 1 ---------*/
class PageEntrance extends StatefulWidget {
  const PageEntrance({super.key});
  @override
  State<PageEntrance> createState() => _PageEntranceState();
}

class _PageEntranceState extends State<PageEntrance> {
  bool _play = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _play = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0B12), Color(0xFF1A1425)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Container(width: 90, height: 180, color: const Color(0xFF3E2A1F)),
                ),
              ),
              AnimatedOpacity(
                opacity: _play ? 0.35 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: Container(color: Colors.white10),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOut,
                alignment: _play ? Alignment.center : const Alignment(-1.4, 0),
                child: const _GhostImage(size: 140),
              ),
              Align(
                alignment: const Alignment(0, -0.75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Booboo enters",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "It’s Booboo’s first Halloween… and this is a real haunted house.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PageTwo()),
              );
            },
            icon: const Icon(Icons.navigate_next),
            label: const Text('Next'),
          ),
        ),
      ),
    );
  }
}


class _GhostImage extends StatelessWidget {
  final double size;
  const _GhostImage({this.size = 120, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/ghost3.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

