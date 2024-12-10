package com.backend.backend.fightGame;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.chatroom.ChatroomRepository;
import com.backend.backend.chatroom.ChatroomService;
import com.backend.backend.fightGame.FightGame;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.UserRepository;
import com.backend.backend.user.UserService;
import com.backend.backend.user.User;
import com.backend.backend.user.Dto.FriendDto;
import com.backend.backend.user.Dto.UserDto;
import com.backend.backend.friendrequest.FriendRequest;
import com.backend.backend.friendrequest.FriendRequestMapper;

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
    public FightGameDto createFightGame(long user1ID, long user2ID, long requesterID) {
        User user1 = userRepository.findById(user1ID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + user1ID));
        User user2 = userRepository.findById(user2ID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + user2ID));
        if (requesterID != 0 && requesterID != user1ID && requesterID != user2ID) {
            throw new ResourceNotFoundException("A faulty request id was given");
        }
        FightGame fightGame = new FightGame();
        fightGame.setUser1(user1);
        fightGame.setUser2(user2);
        fightGame.setRequesterID(requesterID);
        FightGame savedGame = fightGameRepository.save(fightGame);
        userService.addGameSession(user1ID, user2ID, FightGameMapper.mapToFightGameDto(fightGame));
        return FightGameMapper
        .mapToFightGameDto(savedGame);
    }

    @Override
    public FightGameDto getFightGame(long user1ID, long user2ID) {
        User user1 = userRepository.findById(user1ID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + user1ID));
        User user2 = userRepository.findById(user2ID)
        .orElseThrow(() -> new ResourceNotFoundException("User not found" + user2ID));
        List<FightGame> fightGames = fightGameRepository.findByUser1AndUser2(user1, user2);
        if (fightGames.isEmpty()) {
            fightGames = fightGameRepository.findByUser1AndUser2(user2, user1);
            if (fightGames.isEmpty()) {
                throw new ResourceNotFoundException("FightGame not found " + user1ID + " " + user2ID);
            }
            }
        FightGame fightGame = fightGames.get(fightGames.size()-1);
        return FightGameMapper.mapToFightGameDto(fightGame);
    }

    @Override
    public FightGameDto setMove(long id, UserMoveDto userMove) {
        FightGame fightGame = fightGameRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Game not found " + id));
        List<Move> moves;
        if (userMove.getUserID() == fightGame.getUser1().getId()) {
            moves = fightGame.getUser1Moves();
        }
        else if (userMove.getUserID() == fightGame.getUser2().getId()) {
            moves = fightGame.getUser2Moves();
        }
        else {
            throw new ResourceNotFoundException(userMove.getUserID() + " Is not a member of game " + id);
        }
        if (userMove.getMove() == null) {
            throw new ResourceNotFoundException("Bad move was given");
        }
        moves.set(moves.size() - 1, userMove.getMove());
        if (userMove.getUserID() == fightGame.getUser1().getId()) {
            fightGame.setUser1Moves(moves);
        }
        else {
            fightGame.setUser2Moves(moves);
        }
        FightGame savedGame = fightGameRepository.save(fightGame);
        return FightGameMapper
        .mapToFightGameDto(savedGame);
    }

    @Override
    public FightGameDto setNewTurn(long id) {
        FightGame fightGame = fightGameRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("Game not found " + id));
        Move user1Move = fightGame.getUser1Moves().get(fightGame.getUser1Moves().size()-1);
        Move user2Move = fightGame.getUser2Moves().get(fightGame.getUser2Moves().size()-1);
        if (user1Move == Move.NONE || user2Move == Move.NONE) {
            throw new ResourceNotFoundException("The turn is not over");
        }
        else {
            List<Move> user1Moves = fightGame.getUser1Moves();
            List<Move> user2Moves = fightGame.getUser2Moves();
            user1Moves.add(Move.NONE);
            user2Moves.add(Move.NONE);
            fightGame.setUser1Moves(user1Moves);
            fightGame.setUser2Moves(user2Moves);
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
