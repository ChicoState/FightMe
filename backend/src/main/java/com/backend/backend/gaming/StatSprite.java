package com.backend.backend.gaming;

public class StatSprite {
    private double x;
    private double y;
    private String type;

    public StatSprite(double x, double y, String type) {
        this.x = x;
        this.y = y;
        this.type = type;
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public String getType() {
        return type;
    }
}

