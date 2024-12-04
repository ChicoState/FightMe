package com.backend.backend.gaming;

import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;

public class Matchmaking {
    
    private final ConcurrentLinkedQueue<String> waitingPlayers = new ConcurrentLinkedQueue<>();
    
    private final ConcurrentHashMap<String, String> activeMatches = new ConcurrentHashMap<>();

    public String findMatch (String userID){

        if(activeMatches.containsValue(userID)){
            return activeMatches.get(userID);
        }

        String opponent = waitingPlayers.poll();

        if(opponent != null && opponent != userID){
            waitingPlayers.remove(opponent);
            String matchID = UUID.randomUUID().toString();
            activeMatches.put(userID, matchID);
            activeMatches.put(opponent, matchID);
            return matchID;
        }

        //add to waiting queue if no opponent is found
        waitingPlayers.offer(userID);
        return null;
    }

    public String getMatchID(String userID) {
        return activeMatches.get(userID);
    }

    public String getOpponent(String userID, String matchID) {
        return activeMatches.entrySet().stream()
                .filter(entry -> entry.getValue().equals(matchID) && !entry.getKey().equals(userID))
                .map(entry -> entry.getKey())
                .findFirst()
                .orElse(null);
    }

    public void removePlayer(String userID) {
        waitingPlayers.remove(userID);
        activeMatches.remove(userID);
    }

}
