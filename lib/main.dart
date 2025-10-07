import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

/* ---------------- Shared UI ---------------- */

const _bgGradient = LinearGradient(
  colors: [Color(0xFF0B0B12), Color(0xFF1A1425)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

class _PageShell extends StatelessWidget {
  final String? bgAsset;
  final BoxFit bgFit;
  final Alignment bgAlignment;
  final double bottomFadeHeight;
  final Widget body;
  final Widget navBar;

  const _PageShell({
    required this.body,
    required this.navBar,
    this.bgAsset,
    this.bgFit = BoxFit.cover,
    this.bgAlignment = Alignment.center,
    this.bottomFadeHeight = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = (bgAsset != null && bgAsset!.trim().isNotEmpty);
    final background = hasImage
        ? DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgAsset!),
                fit: bgFit,
                alignment: bgAlignment,
                filterQuality: FilterQuality.high,
              ),
            ),
          )
        : const DecoratedBox(decoration: BoxDecoration(gradient: _bgGradient));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          background,
          if (bottomFadeHeight > 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: Container(
                  height: bottomFadeHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.88), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(child: body),
        ],
      ),
      bottomNavigationBar: navBar,
    );
  }
}

Widget _NavBar({
  required BuildContext context,
  VoidCallback? onBack,
  VoidCallback? onNext,
  bool disableBack = false,
  bool disableNext = false,
}) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: disableBack ? null : onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: disableNext ? null : onNext,
              icon: const Icon(Icons.navigate_next),
              label: const Text('Next'),
            ),
          ),
        ],
      ),
    ),
  );
}

TextStyle _outlined(double size, {FontWeight fw = FontWeight.w700, Color fill = Colors.white}) {
  const s = <Shadow>[
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(0, 2)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(0, -2)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(2, 0)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(-2, 0)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1.5, 1.5)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(-1.5, 1.5)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1.5, -1.5)),
    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(-1.5, -1.5)),
  ];
  return TextStyle(color: fill, fontSize: size, fontWeight: fw, shadows: s);
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  const _TitleBlock({required this.title, required this.subtitle, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 8),
      child: Column(
        children: [
          Text(title, style: _outlined(26)),
          const SizedBox(height: 6),
          Text(subtitle, style: _outlined(16, fw: FontWeight.w600, fill: Colors.white70), textAlign: TextAlign.center),
        ],
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
      width: size, height: size,
      child: Image.asset('assets/ghost3.png', fit: BoxFit.contain, filterQuality: FilterQuality.high),
    );
  }
}

class _Floaty extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration period;
  const _Floaty({required this.child, this.amplitude = 14, this.period = const Duration(seconds: 2), super.key});
  @override
  State<_Floaty> createState() => _FloatyState();
}

class _FloatyState extends State<_Floaty> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: widget.period)..repeat(reverse: true);
  late final Animation<double> a = Tween(begin: -widget.amplitude, end: widget.amplitude).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
  @override
  void dispose() { c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: a,
      builder: (context, child) => Transform.translate(offset: Offset(0, a.value), child: child),
      child: widget.child,
    );
  }
}

/* ----------- Scene 1: Entrance ------------ */

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
    return _PageShell(
      bgAsset: 'assets/page1_bg.jpg',
      body: Column(
        children: [
          const _TitleBlock(
            title: "Booboo appears!",
            subtitle: "It’s Booboo the baby ghost's first Halloween… help him achieve his first scare!",
          ),
          Expanded(
            child: Center(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOut,
                alignment: _play ? const Alignment(-0.2, 0.1) : const Alignment(-1.4, 0.1),
                child: const _Floaty(child: _GhostImage(size: 140)),
              ),
            ),
          ),
        ],
      ),
      navBar: _NavBar(
        context: context,
        onBack: () {},
        disableBack: true,
        onNext: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PageThree())),
      ),
    );
  }
}

/* ----------- Scene 2: Mirror ------------ */

class PageThree extends StatefulWidget {
  const PageThree({super.key});
  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> with SingleTickerProviderStateMixin {
  static const double mirrorW = 240;
  static const double mirrorH = 300;
  static const EdgeInsets glassInset = EdgeInsets.fromLTRB(44, 60, 44, 72);
  static const double booTargetX = -0.5;
  static const double booTargetY = 0.18;

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
      setState(() => _booIn = true);
      await Future.delayed(const Duration(milliseconds: 450));
      setState(() => _showReflection = true);
      await Future.delayed(const Duration(milliseconds: 400));
      _shakeC.forward();
    });
  }

  @override
  void dispose() {
    _shakeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      bgAsset: 'assets/page2_bg.jpg',
      body: Column(
        children: [
          const _TitleBlock(title: "Mirror, mirror…", subtitle: "Ahhh! A ghost!! Oh wait... it's just Booboo."),
          Expanded(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _shake,
                  builder: (context, child) {
                    final dx = _shakeC.isAnimating ? _shake.value : 0.0;
                    return Transform.translate(offset: Offset(dx, 0), child: child);
                  },
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeOut,
                    alignment: _booIn ? Alignment(booTargetX, booTargetY) : const Alignment(-1.4, 0.18),
                    child: const _Floaty(child: _GhostImage(size: 120)),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.45, 0.1),
                  child: SizedBox(
                    width: mirrorW,
                    height: mirrorH,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: Image.asset('assets/mirror.png', fit: BoxFit.contain, filterQuality: FilterQuality.high),
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
                                    child: Image.asset('assets/ghost3.png', filterQuality: FilterQuality.high),
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
        ],
      ),
      navBar: _NavBar(
        context: context,
        onBack: () => Navigator.of(context).pop(),
        onNext: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scene2Page())),
      ),
    );
  }
}

/* ----------- Scene 3: Cat ------------ */

class Scene2Page extends StatefulWidget {
  @override
  _Scene2PageState createState() => _Scene2PageState();
}

class _Scene2PageState extends State<Scene2Page> {
  final AudioPlayer _player = AudioPlayer();
  double catTop = 420;
  double catLeft = 80;
  bool catRunning = false;

  Future<void> _onCatTapped() async {
    if (catRunning) return;
    catRunning = true;
    try { await _player.play(AssetSource('assets/catmeow.mp3')); } catch (_) {}
    setState(() => catLeft = MediaQuery.of(context).size.width);
    await Future.delayed(const Duration(seconds: 4));
    setState(() { catTop = 420; catLeft = 80; });
    catRunning = false;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      bgAsset: 'assets/bgsc2.png',
      body: Column(
        children: [
          const _TitleBlock(
            title: "A Scaredy Cat!",
            subtitle: "Booboo sneaks up on the cat. Tap the cat and see what happens!",
          ),
          Expanded(
            child: Stack(
              children: [
                const Positioned(top: 160, left: 40, child: _Floaty(child: _GhostImage(size: 120))),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOut,
                  top: catTop,
                  left: catLeft,
                  child: GestureDetector(
                    onTap: _onCatTapped,
                    child: Image.asset('assets/cat.png', width: 150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      navBar: _NavBar(
        context: context,
        onBack: () => Navigator.of(context).pop(),
        onNext: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scene4Page())),
      ),
    );
  }
}

/* ----------- Scene 4: Following ------------ */

class Scene4Page extends StatefulWidget {
  @override
  _Scene4PageState createState() => _Scene4PageState();
}

class _Scene4PageState extends State<Scene4Page> with SingleTickerProviderStateMixin {
  late final AnimationController drift = AnimationController(vsync: this, duration: const Duration(seconds: 30))..forward();
  late final Animation<double> t = CurvedAnimation(parent: drift, curve: Curves.linear);
  @override
  void dispose() { drift.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final startLeft = 40.0;
    final endLeft = w * 0.58;
    final top = 350.0;

    return _PageShell(
      bgAsset: 'assets/page4&5_bg.jpg',
      bgFit: BoxFit.cover,
      bgAlignment: Alignment.topCenter,
      bottomFadeHeight: 140,
      body: Column(
        children: [
          const _TitleBlock(title: "An unsuspecting child...", subtitle: "Booboo feels confident now. He sneaks up on the child..."),
          Expanded(
            child: AnimatedBuilder(
              animation: t,
              builder: (context, _) {
                final left = startLeft + (endLeft - startLeft) * t.value;
                return Stack(
                  children: [
                    Positioned(top: top, left: w * 0.75, child: Image.asset('assets/kid.png', width: 100)),
                    Positioned(top: top, left: left, child: const _Floaty(child: _GhostImage(size: 110))),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      navBar: _NavBar(
        context: context,
        onBack: () => Navigator.of(context).pop(),
        onNext: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scene5Page())),
      ),
    );
  }
}

/* ----------- Scene 5: Final Scare ------------ */

class Scene5Page extends StatefulWidget {
  @override
  _Scene5PageState createState() => _Scene5PageState();
}

class _Scene5PageState extends State<Scene5Page> with TickerProviderStateMixin {
  late AnimationController approach;
  late Animation<double> at;
  late AnimationController kidShakeC;
  late Animation<double> kidShake;
  bool showWin = false;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    approach = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    at = CurvedAnimation(parent: approach, curve: Curves.easeInOut);
    kidShakeC = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    kidShake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: kidShakeC, curve: Curves.easeInOut));
    approach.addStatusListener((s) async {
      if (s == AnimationStatus.completed) {
        setState(() => showWin = true);
        try { await _player.play(AssetSource('sounds/scary_scream.mp3')); } catch (_) {}
        kidShakeC.forward();
      }
    });
    approach.forward();
  }

  @override
  void dispose() {
    approach.dispose();
    kidShakeC.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final top = 350.0;
    final startLeft = 40.0;
    final targetLeft = w * 0.62;

    return _PageShell(
      bgAsset: 'assets/page4&5_bg.jpg',
      bgFit: BoxFit.cover,
      bgAlignment: Alignment.bottomCenter,
      bottomFadeHeight: 140,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Column(
              children: [
                const _TitleBlock(title: "Success!", subtitle: "BOO! Booboo is a real ghost now!"),
                const SizedBox(height: 6),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showWin ? 1 : 0,
                  child: Text("Happy Halloween!", style: _outlined(24, fw: FontWeight.bold, fill: Colors.yellowAccent)),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: at,
              builder: (context, _) {
                final left = startLeft + (targetLeft - startLeft) * at.value;
                return Stack(
                  children: [
                    Positioned(
                      top: top,
                      left: w * 0.72,
                      child: AnimatedBuilder(
                        animation: kidShake,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(kidShake.value * (showWin ? 1 : 0), 0),
                          child: child,
                        ),
                        child: Image.asset('assets/kid.png', width: 110),
                      ),
                    ),
                    Positioned(top: top, left: left, child: const _Floaty(child: _GhostImage(size: 120))),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      navBar: _NavBar(
        context: context,
        onBack: () => Navigator.of(context).pop(),
        onNext: () {},
        disableNext: true,
      ),
    );
  }
}
