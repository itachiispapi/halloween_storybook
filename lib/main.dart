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

/* ------------- Page 1 ------------- */
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
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scene2Page()));
            },
            icon: const Icon(Icons.navigate_next),
            label: const Text('Next'),
          ),
        ),
      ),
    );
  }
}

/* ------------- Page 2 (Scene 2) ------------- */
class Scene2Page extends StatefulWidget {
  @override
  _Scene2PageState createState() => _Scene2PageState();
}

class _Scene2PageState extends State<Scene2Page>
    with SingleTickerProviderStateMixin {
  late AnimationController _boobooController;
  late Animation<double> _boobooAnimation;

  double catTop = 500;
  double catLeft = 80;
  bool catRunning = false;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _boobooController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _boobooAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _boobooController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _boobooController.dispose();
    _player.dispose();
    super.dispose();
  }

  void _onCatTapped() async {
    if (catRunning) return;
    catRunning = true;

    try {
      await _player.play(AssetSource('assets/catmeow.mp3'));
    } catch (e) {
      print('Audio error: $e');
    }

    setState(() {
      catLeft = MediaQuery.of(context).size.width;
    });

    await Future.delayed(Duration(seconds: 5));
    setState(() {
      catTop = 500;
      catLeft = 80;
    });

    catRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bgsc2.png',
              fit: BoxFit.cover,
            ),
          ),

          AnimatedBuilder(
            animation: _boobooAnimation,
            builder: (context, child) {
              return Positioned(
                top: 100 + _boobooAnimation.value,
                left: 50,
                child: child!,
              );
            },
            child: Image.asset('assets/ghost3.png', width: 100),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            top: catTop,
            left: catLeft,
            child: GestureDetector(
              onTap: _onCatTapped,
              child: Image.asset('assets/cat.png', width: 150),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Text(
              'Booboo tries to scare the cat… but the cat just runs away! **Hint: Tap the cat!**',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),

          Positioned(
            bottom: 10,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PageThree()));
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------- Page 3 ------------- */
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
  static const double booTargetY = 0.22;

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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scene4Page()));
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

/* ------------- Page 4 (Scene 4) ------------- */
class Scene4Page extends StatefulWidget {
  @override
  _Scene4PageState createState() => _Scene4PageState();
}

class _Scene4PageState extends State<Scene4Page>
    with SingleTickerProviderStateMixin {
  double boobooTop = 200;
  double boobooLeft = 50;

  double kidTop = 200;
  double kidLeft = 300;

  bool following = false;
  final AudioPlayer _player = AudioPlayer();

  void _onKidAppears() async {
    if (following) return;
    setState(() {
      following = true;
    });

    try {
      await _player.play(AssetSource('sounds/ghost_follow.wav'));
    } catch (e) {
      print("Audio error: $e");
    }

    setState(() {
      boobooTop = kidTop;
      boobooLeft = kidLeft - 80;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.indigo[900]),

          Positioned(
            top: kidTop,
            left: kidLeft,
            child: Image.asset('assets/kid.png', width: 100),
          ),

          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: boobooTop,
            left: boobooLeft,
            child: Image.asset('assets/ghost3.png', width: 100),
          ),

          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Text(
              'Booboo sees a kid… and starts to follow him quietly!',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),

          Positioned(
            bottom: 10,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scene5Page()));
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------- Page 5 (Scene 5) ------------- */
class Scene5Page extends StatefulWidget {
  @override
  _Scene5PageState createState() => _Scene5PageState();
}

class _Scene5PageState extends State<Scene5Page> with SingleTickerProviderStateMixin {
  double boobooTop = 200;
  double boobooLeft = 50;

  double kidTop = 200;
  double kidLeft = 300;

  bool scared = false;
  final AudioPlayer _player = AudioPlayer();

  void _onScare() async {
    if (scared) return;
    setState(() {
      scared = true;
      boobooTop = kidTop - 50; // Booboo moves closer to scare the kid
      boobooLeft = kidLeft - 30;
    });

    // Play scary sound
    try {
      await _player.play(AssetSource('sounds/scary_scream.mp3'));
    } catch (e) {
      print("Audio error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
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
              // Kid
              AnimatedPositioned(
                duration: Duration(milliseconds: 800),
                top: kidTop,
                left: kidLeft,
                child: Image.asset('assets/kid.png', width: 100),
              ),

              // Booboo
              AnimatedPositioned(
                duration: Duration(seconds: 2),
                curve: Curves.easeInOut,
                top: boobooTop,
                left: boobooLeft,
                child: Image.asset('assets/ghost3.png', width: 100),
              ),

              // Message
              Center(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 800),
                  opacity: scared ? 1.0 : 0.0,
                  child: Text(
                    'BOO! You Win!',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 12, color: Colors.black, offset: Offset(3, 3)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Button to trigger scare
              Positioned(
                bottom: 10,
                right: 20,
                child: ElevatedButton(
                  onPressed: _onScare,
                  child: Text('Scare the Kid'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* --------- Ghost image widget --------- */
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
