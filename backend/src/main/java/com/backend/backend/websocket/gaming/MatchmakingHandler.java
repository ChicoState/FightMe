package com.backend.backend.websocket.gaming;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import com.backend.backend.gaming.Matchmaking;
import com.backend.backend.gaming.SpriteGeneration;
import com.backend.backend.gaming.StatSprite;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Component
public class MatchmakingHandler implements WebSocketHandler {

    private final Matchmaking matchmaking = new Matchmaking();
    private final ConcurrentHashMap<String, WebSocketSession> sessions = new ConcurrentHashMap<>();


    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.put(session.getId(), session);
        session.sendMessage(new TextMessage("Connected"));
    }

    @Override
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
        String userID = session.getId();
        String payload = message.getPayload().toString();
        ObjectMapper mapper = new ObjectMapper();

        if (payload.equals("Find Match")) {
            String matchID = matchmaking.findMatch(userID);
            if (matchID != null) {
                session.sendMessage(new TextMessage("Match Found: " + matchID));
                double player1X = 100.0; // Example fixed position
                double player1Y = 300.0;
                double player2X = 700.0; // Example fixed position
                double player2Y = 300.0;

                ObjectNode player1Response = mapper.createObjectNode();
                player1Response.put("type", "match_start");
                player1Response.put("x_player1", player1X);
                player1Response.put("y_player1", player1Y);
                player1Response.put("x_player2", player2X);
                player1Response.put("y_player2", player2Y);

                // Create response for the second player
                ObjectNode player2Response = mapper.createObjectNode();
                player2Response.put("type", "match_start");
                player2Response.put("x_player1", player2X);
                player2Response.put("y_player1", player2Y);
                player2Response.put("x_player2", player1X);
                player2Response.put("y_player2", player1Y);


                String opponent = matchmaking.getOpponent(userID, matchID);
                WebSocketSession opponentSession = sessions.get(opponent);
                if (opponentSession != null && opponentSession.isOpen()) {
                    opponentSession.sendMessage(new TextMessage("Match Found:" + matchID));
                }
                ObjectNode responseNode = mapper.createObjectNode();
                List<StatSprite> sprites = SpriteGeneration.generateSprites(5);
                responseNode.put("type", "sprites");
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode spritesJsonNode = objectMapper.valueToTree(sprites);
                responseNode.set("sprites", spritesJsonNode);

                session.sendMessage(new TextMessage(mapper.writeValueAsString(responseNode)));
                session.sendMessage(new TextMessage(mapper.writeValueAsString(player1Response)));
                System.out.println("Sending sprites");
                if (opponentSession != null && opponentSession.isOpen()) {
                    opponentSession.sendMessage(new TextMessage(mapper.writeValueAsString(responseNode)));
                    opponentSession.sendMessage(new TextMessage(mapper.writeValueAsString(player2Response)));
                    System.out.println("Sending sprites to the other guy");
                }
            } else {
                session.sendMessage(new TextMessage("Waiting for Match"));
            }
        }
        else{
            ObjectMapper objectMapper = new ObjectMapper();

            JsonNode jsonNode = objectMapper.readTree(payload);
            String messageType = jsonNode.get("type").asText();
            switch (messageType) {
                case "join":
                    String playerPfp = jsonNode.get("playerPfp").asText();
                    String matchID = matchmaking.getMatchID(session.getId());
                    if (matchID != null) {
                        String opponent = matchmaking.getOpponent(userID, matchID);
                        WebSocketSession opponentSession = sessions.get(opponent);
                        if (opponentSession != null && opponentSession.isOpen()) {
                            ObjectMapper mapper2 = new ObjectMapper();
                            ObjectNode responseNode = mapper2.createObjectNode();
                            responseNode.put("type", "join");
                            responseNode.put("playerPfp", playerPfp);
                            
                            opponentSession.sendMessage(new TextMessage(mapper2.writeValueAsString(responseNode)));
                        }
                    }
                break;
            }
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        System.err.println("Transport error: " + exception.getMessage());
        sessions.remove(session.getId());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
        String userID = session.getId();
        matchmaking.removePlayer(userID);
        sessions.remove(userID);
    }

    @Override
    public boolean supportsPartialMessages() {
        return false;
    }

}
