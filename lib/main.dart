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

/* ------------- Page 1 ------------- */
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
                alignment: _play ? const Alignment(-0.2, 0.15) : const Alignment(-1.4, 0.15),
                child: const _GhostImage(size: 140),
              ),
              const Align(
                alignment: Alignment(0, -0.75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Booboo appears!",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "It’s Booboo the baby ghost's first Halloween… and this is a real haunted house.",
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
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PageThree()));
            },
            icon: const Icon(Icons.navigate_next),
            label: const Text('Next'),
          ),
        ),
      ),
    );
  }
}
/* ------------- Page 2 ------------- */
// waiting on code

/* ------------- Page 3 ------------- */
class PageThree extends StatefulWidget {
  const PageThree({super.key});
  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> with SingleTickerProviderStateMixin {
  // Quick knobs to align/size without hunting through code:
  static const double mirrorW = 240;
  static const double mirrorH = 300;
  static const EdgeInsets glassInset = EdgeInsets.fromLTRB(44, 60, 44, 72); // shrink reflection area
  static const double booTargetX = -0.5;  // -1 = far left, +1 = far right
  static const double booTargetY = 0.22;  // -1 = top, +1 = bottom

  bool _booIn = false;
  bool _showReflection = false;
  late final AnimationController _shakeC;
  late final Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _shakeC = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeC, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => _booIn = true);                       // slide in
      await Future.delayed(const Duration(milliseconds: 450));
      setState(() => _showReflection = true);              // show reflection
      await Future.delayed(const Duration(milliseconds: 400));
      _shakeC.forward();                                   // shake
    });
  }

  @override
  void dispose() {
    _shakeC.dispose();
    super.dispose();
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
              const Align(
                alignment: Alignment(0, -0.75),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Mirror, mirror…", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text("Booboo spooks… Himself!", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),

              // Booboo slides in, then shakes
              AnimatedBuilder(
                animation: _shake,
                builder: (context, child) {
                  final dx = _shakeC.isAnimating ? _shake.value : 0.0;
                  return Transform.translate(offset: Offset(dx, 0), child: child);
                },
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOut,
                  alignment: _booIn ? Alignment(booTargetX, booTargetY) : const Alignment(-1.4, 0.22),
                  child: const _GhostImage(size: 120),
                ),
              ),

              // Mirror + reflection
              Align(
                alignment: const Alignment(0.45, 0.12),
                child: SizedBox(
                  width: mirrorW,
                  height: mirrorH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      Positioned.fill(
                        child: Image.asset(
                          'assets/mirror.png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                     
                      Positioned(
                        left: glassInset.left,
                        right: glassInset.right,
                        top: glassInset.top,
                        bottom: glassInset.bottom,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AnimatedOpacity(
                            opacity: _showReflection ? 1 : 0,
                            duration: const Duration(milliseconds: 280),
                            child: AnimatedScale(
                              scale: _showReflection ? 0.92 : 0.82,
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutBack,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Image.asset(
                                    'assets/ghost3.png',
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Next page not implemented yet')),
                    );
                  },
                  icon: const Icon(Icons.navigate_next),
                  label: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------- Ghost image --------- */
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
        errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
