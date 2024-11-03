import 'package:flame/components.dart';

class StatSpriteComponent extends SpriteComponent {
  final String type; 

  StatSpriteComponent({
    required this.type,
    required Sprite sprite,
    Vector2? size,
    Vector2? position,
  }) : super(
          sprite: sprite,
          size: size ?? Vector2(50.0, 50.0),
          position: position ?? Vector2.zero(), // 
        );
        
}
