import 'dart:math';
import 'package:fightme_webapp/game/StatsSpriteComponent.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FightGame extends FlameGame with KeyboardEvents {
  late final String pfp;
  late final SpriteComponent character;
  Vector2 movement = Vector2.zero();
  final List<StatSpriteComponent> statSprites = []; // Changed to correct type
  final Random random = Random();
  int attackCount = 0;
  int defenseCount = 0;
  int magicCount = 0;

  // Game boundaries
  late final Vector2 gameSize;

  FightGame({required this.pfp});
  
  @override
  Color backgroundColor() => const Color.fromARGB(255, 40, 196, 227);

  @override
  Future<void> onLoad() async {
    await super.onLoad(); // Changed to await the super call
    
    gameSize = size; // Store game size for boundary checking
    
    
    character = SpriteComponent()
      ..sprite = await Sprite.load(pfp)
      ..size = Vector2(100.0, 100.0)
      ..position = size / 2 - Vector2(50.0, 50.0);
    await add(character); // Add await here
    
    await spawnSprites(); // Add await here
  }

  @override
  void update(double dt) {
    super.update(dt);
    const double speed = 200.0;
    
    // Calculate new position
    Vector2 newPosition = character.position + movement * speed * dt;
    
    // Keep character within game bounds
    newPosition.x = newPosition.x.clamp(0, gameSize.x - character.size.x);
    newPosition.y = newPosition.y.clamp(0, gameSize.y - character.size.y);
    
    character.position = newPosition;
    
    checkCollisions();
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
  
  Future<void> spawnSprites() async {
    final spriteConfigs = [
      {'type': 'attack', 'filename': 'attack.png'},
      {'type': 'magic', 'filename': 'magic.png'},
      {'type': 'defense', 'filename': 'defense.png'},
    ];
    
    for (int i = 0; i < 5; i++) {
      var config = spriteConfigs[random.nextInt(spriteConfigs.length)];
      
      try {
        final sprite = await Sprite.load(config['filename']!);
        
        final statSprite = StatSpriteComponent(
          type: config['type']!,
          sprite: sprite,
          size: Vector2(50.0, 50.0),
          position: Vector2(
            random.nextDouble() * (size.x - 50),
            random.nextDouble() * (size.y - 50),
          ),
        );
        
        statSprites.add(statSprite);
        await add(statSprite);
      } catch (e) {
        print('Error loading sprite: ${config['filename']} - $e');
      }
    }
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