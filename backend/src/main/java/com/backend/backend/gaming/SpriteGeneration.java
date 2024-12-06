package com.backend.backend.gaming;

import java.util.ArrayList;
import java.util.List;

public class SpriteGeneration {

    private static final double GAME_WIDTH = 800.0;
    private static final double GAME_HEIGHT = 600.0;
    private static final double SPRITE_SIZE = 50.0;


    public static List<StatSprite> generateSprites(int amount) {
        List<StatSprite> sprites = new ArrayList<>();
        for (int i = 0; i < amount; i++) {
            double x = (GAME_WIDTH - SPRITE_SIZE) * Math.random();
            double y = (GAME_HEIGHT - SPRITE_SIZE) * Math.random();
            double typeGen = Math.random();
            String type; 
            if(typeGen < 0.33){
                type = "attack";
            }
            else if(typeGen < 0.33 && typeGen < 0.66){
                type = "defense";
            }
            else{
                type = "magic";
            }
            sprites.add(new StatSprite(x, y, type));
        }
        return sprites;
    }
    
}
