import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const PacManApp());
}

class PacManApp extends StatelessWidget {
  const PacManApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pac-Man',
      theme: ThemeData.dark(),
      home: const MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blue[900]!, Colors.black],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PAC-MAN',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  shadows: [Shadow(color: Colors.orange, blurRadius: 20)],
                ),
              ),
              const SizedBox(height: 60),
              DifficultyButton(
                text: 'FÁCIL',
                color: Colors.green,
                onPressed: () => _startGame(context, Difficulty.easy),
              ),
              const SizedBox(height: 20),
              DifficultyButton(
                text: 'NORMAL',
                color: Colors.blue,
                onPressed: () => _startGame(context, Difficulty.normal),
              ),
              const SizedBox(height: 20),
              DifficultyButton(
                text: 'DIFÍCIL',
                color: Colors.orange,
                onPressed: () => _startGame(context, Difficulty.hard),
              ),
              const SizedBox(height: 20),
              DifficultyButton(
                text: 'EXPERTO',
                color: Colors.red,
                onPressed: () => _startGame(context, Difficulty.expert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, Difficulty difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PacManGame(difficulty: difficulty),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const DifficultyButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 10,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

enum Difficulty { easy, normal, hard, expert }

class PacManGame extends StatefulWidget {
  final Difficulty difficulty;

  const PacManGame({Key? key, required this.difficulty}) : super(key: key);

  @override
  State<PacManGame> createState() => _PacManGameState();
}

class _PacManGameState extends State<PacManGame> with TickerProviderStateMixin {
  static const int rows = 19;
  static const int cols = 19;

  int pacmanPos = 180; // Posición inicial
  String direction = 'right';
  String nextDirection = 'right';
  bool mouthOpen = true;

  // Mapa clásico de Pac-Man estilo laberinto
  List<int> walls = [
    // Borde superior
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
    // Fila 1
    19, 37,
    // Fila 2
    38, 41, 42, 43, 45, 46, 47, 49, 50, 51, 53, 54, 55, 56,
    // Fila 3
    57, 75,
    // Fila 4
    76, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94,
    // Fila 5
    95, 113,
    // Fila 6
    114, 117, 118, 119, 121, 122, 123, 125, 126, 127, 129, 130, 131, 132,
    // Fila 7
    133, 151,
    // Fila 8
    152,
    155,
    156,
    157,
    159,
    160,
    161,
    162,
    163,
    164,
    165,
    166,
    167,
    169,
    170,
    171,
    172,
    // Fila 9
    173, 191,
    // Fila 10 - Centro
    192, 210,
    // Fila 11
    211, 229,
    // Fila 12
    230,
    232,
    233,
    234,
    236,
    237,
    238,
    239,
    240,
    241,
    242,
    243,
    244,
    246,
    247,
    248,
    249,
    // Fila 13
    250, 268,
    // Fila 14
    269,
    272,
    273,
    274,
    275,
    276,
    277,
    278,
    279,
    280,
    281,
    282,
    283,
    284,
    285,
    286,
    287,
    // Fila 15
    288, 306,
    // Fila 16
    307, 310, 311, 312, 314, 315, 316, 318, 319, 320, 322, 323, 324, 325,
    // Fila 17
    326, 344,
    // Borde inferior
    345,
    346,
    347,
    348,
    349,
    350,
    351,
    352,
    353,
    354,
    355,
    356,
    357,
    358,
    359,
    360,
    361,
    362,
    363,
  ];

  List<int> powerPellets = [40, 44, 52, 308, 313, 317, 321];
  List<int> dots = [];
  List<Ghost> ghosts = [];

  int score = 0;
  int level = 1;
  int lives = 3;
  bool gameStarted = false;
  bool gameOver = false;
  bool gamePaused = false;
  bool powerMode = false;
  Timer? gameTimer;
  Timer? powerTimer;
  Timer? animationTimer;

  int get pacmanSpeed {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 250;
      case Difficulty.normal:
        return 200;
      case Difficulty.hard:
        return 150;
      case Difficulty.expert:
        return 120;
    }
  }

  int get ghostCount {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 2;
      case Difficulty.normal:
        return 3;
      case Difficulty.hard:
        return 4;
      case Difficulty.expert:
        return 5;
    }
  }

  double get ghostIntelligence {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return 0.5;
      case Difficulty.normal:
        return 0.7;
      case Difficulty.hard:
        return 0.85;
      case Difficulty.expert:
        return 0.95;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    dots.clear();
    for (int i = 0; i < rows * cols; i++) {
      if (!walls.contains(i) && i != pacmanPos && !powerPellets.contains(i)) {
        dots.add(i);
      }
    }

    ghosts.clear();
    List<Color> ghostColors = [
      Colors.red,
      Colors.pink,
      Colors.cyan,
      Colors.orange,
      const Color(0xFF00FF00),
    ];

    List<int> ghostStartPositions = [194, 195, 196, 213, 214];

    for (int i = 0; i < ghostCount; i++) {
      ghosts.add(
        Ghost(
          position: ghostStartPositions[i],
          color: ghostColors[i],
          direction: 'right',
        ),
      );
    }

    if (level == 1) {
      score = 0;
      lives = 3;
    }
    gameOver = false;
    gamePaused = false;
    powerMode = false;
    direction = 'right';
    nextDirection = 'right';
    pacmanPos = 180;
    mouthOpen = true;
  }

  void startGame() {
    if (gameStarted) return;

    setState(() {
      gameStarted = true;
      gameOver = false;
      gamePaused = false;
    });

    // Timer para la animación de la boca
    animationTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!gamePaused && !gameOver) {
        setState(() {
          mouthOpen = !mouthOpen;
        });
      }
    });

    gameTimer = Timer.periodic(Duration(milliseconds: pacmanSpeed), (timer) {
      if (gameOver || gamePaused) {
        return;
      }

      setState(() {
        movePacman();
        moveGhosts();
        checkCollisions();
      });
    });
  }

  void togglePause() {
    setState(() {
      gamePaused = !gamePaused;
    });
  }

  void movePacman() {
    // Intentar cambiar de dirección si es posible
    if (canMove(pacmanPos, nextDirection)) {
      direction = nextDirection;
    }

    int newPos = getNewPosition(pacmanPos, direction);

    // Solo moverse si no hay pared
    if (canMove(pacmanPos, direction)) {
      pacmanPos = newPos;

      // Comprobar túneles (atravesar bordes laterales)
      if (pacmanPos % cols == 0 && direction == 'left') {
        pacmanPos += cols - 1;
      } else if (pacmanPos % cols == cols - 1 && direction == 'right') {
        pacmanPos -= cols - 1;
      }

      if (dots.contains(pacmanPos)) {
        dots.remove(pacmanPos);
        score += 10;

        if (dots.isEmpty && powerPellets.isEmpty) {
          nextLevel();
        }
      }

      if (powerPellets.contains(pacmanPos)) {
        powerPellets.remove(pacmanPos);
        score += 50;
        activatePowerMode();

        if (dots.isEmpty && powerPellets.isEmpty) {
          nextLevel();
        }
      }
    }
  }

  void activatePowerMode() {
    powerMode = true;
    powerTimer?.cancel();

    powerTimer = Timer(const Duration(seconds: 7), () {
      setState(() {
        powerMode = false;
      });
    });
  }

  void nextLevel() {
    gameTimer?.cancel();
    animationTimer?.cancel();
    powerTimer?.cancel();
    level++;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue[900],
        title: const Text(
          '¡Nivel Completado!',
          style: TextStyle(color: Colors.yellow),
        ),
        content: Text(
          'Nivel: $level\nPuntuación: $score',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                int currentScore = score;
                int currentLevel = level;
                int currentLives = lives;
                initializeGame();
                score = currentScore;
                level = currentLevel;
                lives = currentLives;
                gameStarted = false;
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                startGame();
              });
            },
            child: const Text(
              'Continuar',
              style: TextStyle(color: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  void moveGhosts() {
    for (var ghost in ghosts) {
      List<String> possibleDirections = [];

      for (var dir in ['up', 'down', 'left', 'right']) {
        if (canMove(ghost.position, dir) &&
            dir != getOppositeDirection(ghost.direction)) {
          possibleDirections.add(dir);
        }
      }

      if (possibleDirections.isEmpty) {
        String opposite = getOppositeDirection(ghost.direction);
        if (canMove(ghost.position, opposite)) {
          possibleDirections.add(opposite);
        }
      }

      if (possibleDirections.isNotEmpty) {
        if (powerMode) {
          // En modo power, los fantasmas huyen
          String escapeDir = getEscapeDirection(ghost.position, pacmanPos);
          if (possibleDirections.contains(escapeDir)) {
            ghost.direction = escapeDir;
          } else {
            ghost.direction =
                possibleDirections[Random().nextInt(possibleDirections.length)];
          }
        } else {
          // Modo normal: perseguir según inteligencia
          if (Random().nextDouble() < ghostIntelligence) {
            String bestDir = getBestDirection(ghost.position, pacmanPos);
            if (possibleDirections.contains(bestDir)) {
              ghost.direction = bestDir;
            } else {
              ghost.direction =
                  possibleDirections[Random().nextInt(
                    possibleDirections.length,
                  )];
            }
          } else {
            ghost.direction =
                possibleDirections[Random().nextInt(possibleDirections.length)];
          }
        }

        ghost.position = getNewPosition(ghost.position, ghost.direction);
      }
    }
  }

  String getOppositeDirection(String dir) {
    switch (dir) {
      case 'up':
        return 'down';
      case 'down':
        return 'up';
      case 'left':
        return 'right';
      case 'right':
        return 'left';
      default:
        return 'up';
    }
  }

  String getBestDirection(int from, int to) {
    int fromRow = from ~/ cols;
    int fromCol = from % cols;
    int toRow = to ~/ cols;
    int toCol = to % cols;

    int rowDiff = toRow - fromRow;
    int colDiff = toCol - fromCol;

    if (rowDiff.abs() > colDiff.abs()) {
      return rowDiff > 0 ? 'down' : 'up';
    } else {
      return colDiff > 0 ? 'right' : 'left';
    }
  }

  String getEscapeDirection(int from, int to) {
    String chaseDir = getBestDirection(from, to);
    return getOppositeDirection(chaseDir);
  }

  bool canMove(int pos, String dir) {
    int newPos = getNewPosition(pos, dir);

    // Validar límites del tablero
    if (newPos < 0 || newPos >= rows * cols) {
      return false;
    }

    // Validar que no cruce bordes verticales incorrectamente
    int currentRow = pos ~/ cols;
    int currentCol = pos % cols;
    int newRow = newPos ~/ cols;
    int newCol = newPos % cols;

    // Evitar saltos de fila al moverse horizontalmente
    if (dir == 'left' && currentCol == 0 && newCol == cols - 1) {
      return true; // Permitir túnel
    }
    if (dir == 'right' && currentCol == cols - 1 && newCol == 0) {
      return true; // Permitir túnel
    }
    if ((dir == 'left' || dir == 'right') && currentRow != newRow) {
      return false;
    }

    return !walls.contains(newPos);
  }

  int getNewPosition(int pos, String dir) {
    int col = pos % cols;

    switch (dir) {
      case 'up':
        return pos - cols;
      case 'down':
        return pos + cols;
      case 'left':
        if (col == 0) {
          return pos + cols - 1; // Túnel izquierdo
        }
        return pos - 1;
      case 'right':
        if (col == cols - 1) {
          return pos - cols + 1; // Túnel derecho
        }
        return pos + 1;
      default:
        return pos;
    }
  }

  void checkCollisions() {
    for (var ghost in ghosts) {
      if (ghost.position == pacmanPos) {
        if (powerMode) {
          // Comer fantasma
          score += 200;
          ghost.position = 199; // Volver al centro
          ghost.direction = 'right';
        } else {
          // Perder vida
          lives--;
          if (lives <= 0) {
            gameOver = true;
            gameTimer?.cancel();
            animationTimer?.cancel();
            powerTimer?.cancel();
            showGameOverDialog();
          } else {
            // Pausar brevemente y resetear posiciones
            gamePaused = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              resetPositions();
              setState(() {
                gamePaused = false;
              });
            });
          }
        }
        break;
      }
    }
  }

  void resetPositions() {
    pacmanPos = 180;
    direction = 'right';
    nextDirection = 'right';

    List<int> ghostStartPositions = [194, 195, 196, 213, 214];
    for (int i = 0; i < ghosts.length; i++) {
      ghosts[i].position = ghostStartPositions[i];
      ghosts[i].direction = 'right';
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[900],
        title: const Text('¡Game Over!', style: TextStyle(color: Colors.white)),
        content: Text(
          'Nivel alcanzado: $level\nPuntuación: $score',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Menú', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                level = 1;
                gameStarted = false;
                initializeGame();
              });
            },
            child: const Text(
              'Reintentar',
              style: TextStyle(color: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    powerTimer?.cancel();
    animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Marcador
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SCORE: $score',
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'NIVEL: $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(
                      lives,
                      (index) => const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (gameStarted && !gameOver)
                        IconButton(
                          onPressed: togglePause,
                          icon: Icon(
                            gamePaused ? Icons.play_arrow : Icons.pause,
                            color: Colors.yellow,
                          ),
                          tooltip: gamePaused ? 'Reanudar' : 'Pausar',
                        ),
                      if (!gameStarted)
                        ElevatedButton(
                          onPressed: startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            'INICIAR',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Tablero del juego
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy.abs() > 3) {
                        setState(() {
                          nextDirection = details.delta.dy < 0 ? 'up' : 'down';
                        });
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx.abs() > 3) {
                        setState(() {
                          nextDirection = details.delta.dx < 0
                              ? 'left'
                              : 'right';
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                      child: Stack(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                ),
                            itemCount: rows * cols,
                            itemBuilder: (context, index) {
                              if (walls.contains(index)) {
                                return Container(
                                  margin: const EdgeInsets.all(0.5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                );
                              } else if (pacmanPos == index) {
                                return Center(
                                  child: PacManWidget(
                                    direction: direction,
                                    mouthOpen: mouthOpen,
                                  ),
                                );
                              } else if (ghosts.any(
                                (g) => g.position == index,
                              )) {
                                var ghost = ghosts.firstWhere(
                                  (g) => g.position == index,
                                );
                                return Center(
                                  child: GhostWidget(
                                    color: powerMode
                                        ? Colors.blue[300]!
                                        : ghost.color,
                                    scared: powerMode,
                                  ),
                                );
                              } else if (powerPellets.contains(index)) {
                                return Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellow.withOpacity(0.8),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (dots.contains(index)) {
                                return Center(
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Colors.yellow,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          // Overlay de pausa
                          if (gamePaused)
                            Container(
                              color: Colors.black.withOpacity(0.7),
                              child: const Center(
                                child: Text(
                                  'PAUSA',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.orange,
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ), // Indicador de modo power
            if (powerMode)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue[300],
                child: const Text(
                  '⚡ MODO POWER ⚡',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Instrucciones
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                gameStarted
                    ? 'Desliza para mover${gamePaused ? ' • Toca ▶ para continuar' : ' • Come los puntos'}'
                    : 'Toca INICIAR para comenzar • Desliza para controlar',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Ghost {
  int position;
  Color color;
  String direction;

  Ghost({
    required this.position,
    required this.color,
    this.direction = 'right',
  });
}

class PacManWidget extends StatelessWidget {
  final String direction;
  final bool mouthOpen;

  const PacManWidget({Key? key, required this.direction, this.mouthOpen = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rotation = 0;
    switch (direction) {
      case 'up':
        rotation = -pi / 2;
        break;
      case 'down':
        rotation = pi / 2;
        break;
      case 'left':
        rotation = pi;
        break;
      case 'right':
        rotation = 0;
        break;
    }

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: mouthOpen ? CustomPaint(painter: PacManPainter()) : null,
      ),
    );
  }
}

class PacManPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GhostWidget extends StatelessWidget {
  final Color color;
  final bool scared;

  const GhostWidget({Key? key, required this.color, this.scared = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
          bottom: Radius.circular(2),
        ),
        boxShadow: scared
            ? [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 4)]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
