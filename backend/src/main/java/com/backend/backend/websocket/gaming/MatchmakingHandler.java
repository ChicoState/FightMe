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

        // Fixed spawn locations for players
        double player1X = 100.0;
        double player1Y = 300.0;
        double player2X = 700.0;
        double player2Y = 300.0;

        if (payload.equals("Find Match")) {
            String matchID = matchmaking.findMatch(userID);
            if (matchID != null) {
                session.sendMessage(new TextMessage("Match Found: " + matchID));

                String opponent = matchmaking.getOpponent(userID, matchID);
                WebSocketSession opponentSession = sessions.get(opponent);
                if (opponentSession != null && opponentSession.isOpen()) {
                    opponentSession.sendMessage(new TextMessage("Match Found: " + matchID));
                }

                ObjectNode responseNode = mapper.createObjectNode();
                List<StatSprite> sprites = SpriteGeneration.generateSprites(5);
                responseNode.put("type", "sprites");
                JsonNode spritesJsonNode = mapper.valueToTree(sprites);
                responseNode.set("sprites", spritesJsonNode);

                session.sendMessage(new TextMessage(mapper.writeValueAsString(responseNode)));
                if (opponentSession != null && opponentSession.isOpen()) {
                    opponentSession.sendMessage(new TextMessage(mapper.writeValueAsString(responseNode)));
                }
                // Set player number to 1 for player 1 and 2 for player 2
                ObjectNode setPlayer1Node = mapper.createObjectNode();
                setPlayer1Node.put("type", "player_number");
                setPlayer1Node.put("player_number", 1);
                session.sendMessage(new TextMessage(mapper.writeValueAsString(setPlayer1Node)));
                ObjectNode setPlayer2Node = mapper.createObjectNode();
                setPlayer2Node.put("type", "player_number");
                setPlayer2Node.put("player_number", 2);
                opponentSession.sendMessage(new TextMessage(mapper.writeValueAsString(setPlayer2Node)));

                // Send position of player 1 to player 2
                ObjectNode player1PosResponse = mapper.createObjectNode();
                player1PosResponse.put("type", "spawn_locations");
                player1PosResponse.put("x_player1", player1X);
                player1PosResponse.put("y_player1", player1Y);
                player1PosResponse.put("x_player2", player2X);
                player1PosResponse.put("y_player2", player2Y);
                session.sendMessage(new TextMessage(mapper.writeValueAsString(player1PosResponse)));

                if (opponentSession != null && opponentSession.isOpen()) {
                    ObjectNode player2PosResponse = mapper.createObjectNode();
                    player2PosResponse.put("type", "spawn_locations");
                    player2PosResponse.put("x_player2", player2X);
                    player2PosResponse.put("y_player2", player2Y);
                    player2PosResponse.put("x_player1", player1X);
                    player2PosResponse.put("y_player1", player1Y);
                    opponentSession.sendMessage(new TextMessage(mapper.writeValueAsString(player2PosResponse)));
                }

            }
            else {
                session.sendMessage(new TextMessage("Waiting for Match"));
            }
        } 
        else {
            JsonNode jsonNode = mapper.readTree(payload);
            String messageType = jsonNode.get("type").asText();
            switch (messageType) {
                case "join":
                    String playerPfp = jsonNode.get("playerPfp").asText();
                    String matchID = matchmaking.getMatchID(session.getId());
                    if (matchID != null) {
                        String opponent = matchmaking.getOpponent(userID, matchID);
                        WebSocketSession opponentSession = sessions.get(opponent);
                        if (opponentSession != null && opponentSession.isOpen()) {
                            ObjectNode responseNode = mapper.createObjectNode();
                            responseNode.put("type", "join");
                            responseNode.put("playerPfp", playerPfp);
                            opponentSession.sendMessage(new TextMessage(mapper.writeValueAsString(responseNode)));
                        }
                    }
                    break;
                case "move": 
                    matchID = matchmaking.getMatchID(userID);
                    if (matchID != null) {
                        String opponent = matchmaking.getOpponent(userID, matchID);
                        WebSocketSession opponentSession = sessions.get(opponent);
        
                        if (opponentSession != null && opponentSession.isOpen()) {
                            opponentSession.sendMessage(new TextMessage(payload));
                        }
                    }
                    break;
                case "collect":
                    matchID = matchmaking.getMatchID(userID);
                    if (matchID != null) {
                        String opponent = matchmaking.getOpponent(userID, matchID);
                        WebSocketSession opponentSession = sessions.get(opponent);
        
                        if (opponentSession != null && opponentSession.isOpen()) {
                            opponentSession.sendMessage(new TextMessage(payload));
                        }
                    }
                    break;
                case "game_end":
                    System.out.println("Game end message received");
                    matchID = matchmaking.getMatchID(userID);
                    if (matchID != null) {
                        String opponent = matchmaking.getOpponent(userID, matchID);
                        WebSocketSession opponentSession = sessions.get(opponent);
        
                        if (opponentSession != null && opponentSession.isOpen()) {
                            opponentSession.sendMessage(new TextMessage(payload));
                            System.out.println("Sending game end message to opponent");
                        }
                        matchmaking.endMatch(matchID);
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
