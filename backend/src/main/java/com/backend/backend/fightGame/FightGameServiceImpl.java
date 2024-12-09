package com.backend.backend.fightGame;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.chatroom.ChatroomRepository;
import com.backend.backend.chatroom.ChatroomService;
import com.backend.backend.fightGame.FightGame;
import com.backend.backend.fightGame.FightGameRepository;
import com.backend.backend.fightGame.FightGameService;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.UserRepository;
import com.backend.backend.user.UserService;
import com.backend.backend.user.User;
import com.backend.backend.user.Dto.FriendDto;
import com.backend.backend.user.Dto.UserDto;
import com.backend.backend.friendrequest.FriendRequest;

import lombok.AllArgsConstructor;

import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.fightGame.Dto.UserMoveDto;
import com.backend.backend.friendrequest.FriendRequestRepository;
import com.backend.backend.friendrequest.FriendRequestService;
import com.backend.backend.fightGame.FightGame.Move;

@Service
@AllArgsConstructor
public class FightGameServiceImpl implements FightGameService{
    private FightGameRepository fightGameRepository;
    private FriendRequestRepository friendRequestRepository;
    private FriendRequestService friendRequestService;
    private UserRepository userRepository;
    private UserService userService;
    private ChatroomService chatroomService;
    
    // START OF ALL CREATE

    @Override
    public FightGameDto createFightGame(long user1ID, long user2ID, long requestID) {
        User user1 = userRepository.findById(user1ID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + user1ID));
        User user2 = userRepository.findById(user2ID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + user2ID));
        if (requestID != 0 && requestID != user1ID && requestID != user2ID) {
            throw new ResourceNotFoundException("A faulty request id was given");
        }
        FightGame fightGame = new FightGame();
        fightGame.setUser1(user1);
        fightGame.setUser2(user2);
        fightGame.setRequesterID(requestID);
        Map<Long, List<Move>> initMoves = new HashMap<>();
        initMoves.put(user1.getId(), Arrays.asList(Move.NONE));
        initMoves.put(user2.getId(), Arrays.asList(Move.NONE));
        fightGame.setMoves(initMoves);
        FightGame savedGame = fightGameRepository.save(fightGame);
        return FightGameMapper
        .mapToFightGameDto(savedGame);
    }

    @Override
    public FightGameDto setMove(long id, UserMoveDto userMove) {
        FightGame fightGame = fightGameRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Game not found " + id));
        Map<Long, List<Move>> moves = fightGame.getMoves();
        if (moves.size() == 0) {
            throw new ResourceNotFoundException("Game moves was not established " + id);
        }
        moves.get(userMove.getUserID()).set(moves.get(userMove.getUserID()).size() - 1, userMove.getMove());
        fightGame.setMoves(moves);
        FightGame savedGame = fightGameRepository.save(fightGame);
        return FightGameMapper
        .mapToFightGameDto(savedGame);
    }

    @Override
    public FightGameDto setNewTurn(long id) {
        FightGame fightGame = fightGameRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Game not found " + id));
        Move user1Move = fightGame.getMoves().get(fightGame.getUser1().getId()).getLast();
        Move user2Move = fightGame.getMoves().get(fightGame.getUser2().getId()).getLast();
        if (user1Move == Move.NONE || user2Move == Move.NONE) {
            throw new ResourceNotFoundException("The turn is not over");
        }
        else {
            Map<Long, List<Move>> moves = fightGame.getMoves();
            moves.get(fightGame.getUser1().getId()).add(Move.NONE);
            moves.get(fightGame.getUser2().getId()).add(Move.NONE);
            fightGame.setMoves(moves);
            FightGame savedGame = fightGameRepository.save(fightGame);
        return FightGameMapper
        .mapToFightGameDto(savedGame);
        }
    }

    @Override
    public FightGameDto declareWinner(long id) {
        FightGame fightGame = fightGameRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Game not found" + id));
        if (fightGame.getUser1HP() == 0 || fightGame.getUser2HP() == 0) {
            if (fightGame.getUser1HP() == 0 && fightGame.getUser2HP() != 0) {
                fightGame.setWinnerID(fightGame.getUser2().getId().intValue());
            }
            else if (fightGame.getUser1HP() != 0 && fightGame.getUser2HP() == 0) {
                fightGame.setWinnerID(fightGame.getUser1().getId().intValue());
            }
            else {
                fightGame.setWinnerID(-1);
            }
            if (fightGame.getRequesterID() != 0) {
                if (fightGame.getWinnerID() == fightGame.getRequesterID().intValue()) {
                    
                    userService.addFriend(fightGame.getRequesterID(), new FriendDto(fightGame.getUser1().getId().intValue() == fightGame.getWinnerID() ? fightGame.getUser2().getId() : fightGame.getUser1().getId()));
                    chatroomService.createChatroom(null);
                }
                else {
                    FriendRequest incoming = friendRequestRepository.findByFromUserIDAndToUserID(fightGame.getRequesterID(), Long.valueOf(fightGame.getWinnerID()))
                    .orElseThrow(() -> new ResourceNotFoundException("FriendRequest not found " + fightGame.getRequesterID() + " " + Long.valueOf(fightGame.getWinnerID())));
                    friendRequestService.rejectFriendRequest(incoming.getId());
                }
            }
            FightGame savedGame = fightGameRepository.save(fightGame);
            return FightGameMapper.mapToFightGameDto(savedGame);
        }
        else {
            throw new ResourceNotFoundException("The game is not finished.");
        }
    }
}
