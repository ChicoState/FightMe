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
  late final String pfp;
  late final SpriteComponent character;
  late final SpriteComponent opponentCharacter;
  late final String matchID;
  late final WebSocketChannel channel;
  late StreamSubscription streamSubscription; 
  Vector2 movement = Vector2.zero();
  final List<StatSpriteComponent> statSprites = []; // Changed to correct type
  final Random random = Random();
  int attackCount = 0;
  int defenseCount = 0;
  int magicCount = 0;

  // Game boundaries
  late final Vector2 gameSize;

  late Stream<dynamic> broadcastStream;

  FightGame({required this.pfp, required this.matchID, required this.channel, required this.broadcastStream}){
  }
  
  @override
  Color backgroundColor() => const Color.fromARGB(255, 40, 196, 227);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Changed to await the super call

    streamSubscription = broadcastStream.listen((message) {
      _handleWebSocketMessage(message);
    });
    
    gameSize = size; // Store game size for boundary checking

    channel.sink.add(jsonEncode({
      'type': 'join',
      'playerPfp': pfp,
    }));

    character = SpriteComponent()
      ..sprite = await Sprite.load(pfp)
      ..size = Vector2(50.0, 50.0)
      ..position = size / 2 - Vector2(50.0, 50.0);
    await add(character);
    
    
    // await spawnSprites(); // Add await here
  }
  @override
  void onRemove (){
    streamSubscription.cancel();
    channel.sink.close();
    super.onRemove();
  }

  // What the server sends and tracks 
  void _handleWebSocketMessage(String message) {
  // Check if the message is a valid JSON string
  try {
    final data = jsonDecode(message);
    switch (data['type']) {
      case 'join': 
        _loadOpponent(data['playerPfp']);
        print("Opponent joined");
        break;
      case 'move':
        _updatePosition(data['x'], data['y']);
        print("Opponent move received");
        break;
      case 'collect':
        _updateSprites(data['statType'], data['x'], data['y']);
        break;
      case 'sprites': 
        List<dynamic> spritesList = data['sprites'];
        List<Map<String, dynamic>> convertedSprites = spritesList.map((sprite) {
          return {
            'x': (sprite['x'] as num).toDouble(),
            'y': (sprite['y'] as num).toDouble(),
            'type': sprite['type'] as String
          };
        }).toList();
        _spawnSprites(convertedSprites);
        print("Sprites received");
        break;
      case 'match_start': 
        // _moveCharacters(data['x_player1'], data['y_player1'], data['x_player2'], data['y_player2']);
        break;
      default:
        print("Unknown message type received");
    }
  } catch (e) {
    // If jsonDecode fails, it means the message is not valid JSON
    print("Error decoding message: $e");
  }
}

  Future<void> _loadOpponent(String pfp) async {
    opponentCharacter = SpriteComponent()
      ..sprite = await Sprite.load(pfp)
      ..size = Vector2(50.0, 50.0)
      ..position = size / 2 + Vector2(50.0, 50.0);
    await add(opponentCharacter);
  }

  void _updatePosition(double x, double y) {
    opponentCharacter.position = Vector2(x, y);
  }

  void _updateSprites(String statType, double x, double y) {
    for (var statSprite in statSprites) {
      if (statSprite.type == statType && statSprite.position.x == x && statSprite.position.y == y) {
        statSprite.removeFromParent();
        statSprites.remove(statSprite);
      }
    }
  }

  void _spawnSprites(List<Map<String, dynamic>> sprites) async {
    for (var sprite in sprites) {
      print("Spawning sprite: ${sprite['type']}");
      final type = sprite['type'];
      final position = Vector2(sprite['x'], sprite['y']);

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

  // void _moveCharacters(double x1, double y1, double x2, double y2) {
  //   character.position = Vector2(x1, y1);
  //   opponentCharacter.position = Vector2(x2, y2);
  // }

  @override
  void update(double dt) {
    super.update(dt);
    if (movement.length > 0) {
      print("Sending a move");
      channel.sink.add(jsonEncode({
        'type': 'move',
        'x': character.position.x,
        'y': character.position.y,
      }));
    }
    const double speed = 200.0;
    
    // Calculate new position
    Vector2 newPosition = character.position + movement * speed * dt;
    
    // Keep character within game bounds
    newPosition.x = newPosition.x.clamp(0, gameSize.x - character.size.x);
    newPosition.y = newPosition.y.clamp(0, gameSize.y - character.size.y);
    
    character.position = newPosition;
    
    checkCollisions();

    // if(statSprites.isEmpty){
    //   pauseEngine();
    //   saveStats();
    // }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Only process key events when they change
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
    // Create a copy of the list to safely modify during iteration
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
        
        // Remove sprite safely
        statSprite.removeFromParent();
        statSprites.remove(statSprite);

        channel.sink.add(jsonEncode({
          'type': 'collect',
          'statType': statSprite.type,
          'x': statSprite.position.x,
          'y': statSprite.position.y,
        }));
        
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
}