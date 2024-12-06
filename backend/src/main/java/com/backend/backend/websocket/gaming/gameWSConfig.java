package com.backend.backend.websocket.gaming;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class gameWSConfig implements WebSocketConfigurer{

    private final MatchmakingHandler matchmakingHandler;

    public gameWSConfig(MatchmakingHandler matchmakingHandler) {
        this.matchmakingHandler = matchmakingHandler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(matchmakingHandler, "/ws/matchmaking")
                .setAllowedOrigins("*");
        registry.addHandler(matchmakingHandler, "/ws/matchmaking/{matchID}")
            .setAllowedOrigins("*");
    }

    
}
