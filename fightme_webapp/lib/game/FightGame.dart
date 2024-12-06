import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fightme_webapp/game/StatsSpriteComponent.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FightGame extends FlameGame with KeyboardEvents {
  final VoidCallback onGameEnd;
  late final String pfp;
  late final SpriteComponent character;
  late final SpriteComponent opponentCharacter;
  late final String matchID;
  late final WebSocketChannel channel;
  late StreamSubscription streamSubscription; 
  Vector2 movement = Vector2.zero();
  final List<StatSpriteComponent> statSprites = [];
  final Random random = Random();
  int attackCount = 0;
  int defenseCount = 0;
  int magicCount = 0;
  int playerNumber = 0;
  double x1 = 0;
  double y1 = 0;
  double x2 = 0; 
  double y2 = 0;

  late final Vector2 gameSize;

  late Stream<dynamic> broadcastStream;

  FightGame({required this.pfp, required this.matchID, required this.channel, required this.broadcastStream, required this.onGameEnd,});

  @override
  Color backgroundColor() => const Color.fromARGB(255, 40, 196, 227);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    streamSubscription = broadcastStream.listen((message) {
      _handleWebSocketMessage(message as String);
    });

    gameSize = size; // Store game size for boundary checking

    channel.sink.add(jsonEncode({'type': 'join', 'playerPfp': pfp}));

    character = SpriteComponent()
      ..sprite = await Sprite.load(pfp)
      ..size = Vector2(50.0, 50.0)
      ..position = (playerNumber == 1 ? Vector2(x1, y1) : Vector2(x2, y1));
    await add(character);

  }

  @override
  void onRemove() {
    streamSubscription.cancel();
    channel.sink.close();
    super.onRemove();
  }

  void _handleWebSocketMessage(String message) {
    try {
      final data = jsonDecode(message);
      switch (data['type']) {
        case 'join': 
          _loadOpponent(data['playerPfp']);
          break;
        case 'move':
          _updatePosition(data['x'], data['y']);
          break;
        case 'collect':
          _updateSprites(data['statType'], data['x'], data['y']);
          break;
        case 'sprites': 
          _spawnSprites(data['sprites']);
          break;
        case 'spawn_locations':
          _handleSpawnLocations(data['x_player1'], data['y_player1'], data['x_player2'], data['y_player2']);
          break;
        case 'player_number':
          playerNumber = data['player_number'];
          break;
        case 'game_end':
          pauseEngine();
          saveStats();
          onGameEnd();
          break;
        default:
          print("Unknown message type received: ${data['type']}");
      }
    } catch (e) {
      print("Error decoding message: $e");
    }
  }

  Future<void> _loadOpponent(String pfp) async {
    print("Loading opponent");
    opponentCharacter = SpriteComponent()
      ..sprite = await Sprite.load(pfp)
      ..size = Vector2(50.0, 50.0)
      ..position = (playerNumber == 1 ? Vector2(x2, y2) : Vector2(x1, y1));
    await add(opponentCharacter);
  }

  void _updatePosition(double x, double y) {
    opponentCharacter.position = Vector2(x, y);
  }

  void _updateSprites(String statType, double x, double y) {
    statSprites.removeWhere((sprite) {
      final matches = sprite.type == statType && sprite.position.x == x && sprite.position.y == y;
      if (matches) sprite.removeFromParent();
      return matches;
    });
  }

  void _spawnSprites(List<dynamic> sprites) async {
    for (var sprite in sprites) {
      final type = sprite['type'];
      final position = Vector2((sprite['x'] as num).toDouble(), (sprite['y'] as num).toDouble());

      final statSprite = StatSpriteComponent(
        type: type,
        position: position,
        size: Vector2(25.0, 25.0),
        sprite: await Sprite.load('$type.png'),
      );
      statSprites.add(statSprite);
      await add(statSprite);
    }
  }


  @override
  void update(double dt) {
    super.update(dt);

    if (movement.length > 0) {
      channel.sink.add(jsonEncode({
        'type': 'move',
        'x': character.position.x,
        'y': character.position.y,
      }));
    }

    const double speed = 200.0;
    Vector2 newPosition = character.position + movement * speed * dt;
    newPosition.x = newPosition.x.clamp(0, gameSize.x - character.size.x);
    newPosition.y = newPosition.y.clamp(0, gameSize.y - character.size.y);
    character.position = newPosition;

    checkCollisions();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyUpEvent || event is KeyDownEvent) {
      movement.setZero();
      if (keysPressed.contains(LogicalKeyboardKey.keyW)) movement.y -= 1;
      if (keysPressed.contains(LogicalKeyboardKey.keyS)) movement.y += 1;
      if (keysPressed.contains(LogicalKeyboardKey.keyA)) movement.x -= 1;
      if (keysPressed.contains(LogicalKeyboardKey.keyD)) movement.x += 1;

      if (movement.length > 1) movement.normalize();
    }
    return KeyEventResult.handled;
  }

  void checkCollisions() {
    final spritesToCheck = List<StatSpriteComponent>.from(statSprites);
    for (var statSprite in spritesToCheck) {
      if (character.toRect().overlaps(statSprite.toRect())) {
        switch (statSprite.type) {
          case 'attack':
            attackCount++;
            break;
          case 'magic':
            magicCount++;
            break;
          case 'defense':
            defenseCount++;
            break;
        }
        statSprite.removeFromParent();
        statSprites.remove(statSprite);

        channel.sink.add(jsonEncode({
          'type': 'collect',
          'statType': statSprite.type,
          'x': statSprite.position.x,
          'y': statSprite.position.y,
        }));

        if(statSprites.isEmpty){
        channel.sink.add(jsonEncode({
          'type': 'game_end'
        }));
        pauseEngine();
        saveStats();
        onGameEnd();
      }
      }
    }
  }

  Map<String, int> saveStats() {
    return {
      'attackScore': attackCount,
      'magicScore': magicCount,
      'defenseScore': defenseCount,
    };
  }
  
  void _handleSpawnLocations(double x_1, double y_1, double x_2, double y_2) {
    x1 = x_1;
    y1 = y_1;
    x2 = x_2;
    y2 = y_2;
  }

}