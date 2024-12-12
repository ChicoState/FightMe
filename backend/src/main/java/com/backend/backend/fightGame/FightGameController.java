package com.backend.backend.fightGame;

import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.friendrequest.FriendRequestDto;
import com.backend.backend.fightGame.FightGame.Move;
import com.backend.backend.fightGame.FightGameService;
import com.backend.backend.user.User;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.Dto.UserDto;
import com.backend.backend.fightGame.Dto.UserMoveDto;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/api/fightgames")
@AllArgsConstructor
@CrossOrigin(origins = "*")
public class FightGameController {
    private FightGameService fightGameService;

    @PostMapping
    public ResponseEntity<FightGameDto> createFightGame(@RequestBody FightGameDto fightGameDto) {
        Long user1 = fightGameDto.getUser1().getId();
        Long user2 = fightGameDto.getUser2().getId();
        Long requesterID = fightGameDto.getRequesterID();
        FightGameDto savedFightGame = fightGameService.createFightGame(user1, user2, requesterID);
        return new ResponseEntity<>(savedFightGame, HttpStatus.CREATED);
    }

    @GetMapping("{user1ID}/{user2ID}")
    public ResponseEntity<FightGameDto> getFightGame(@PathVariable("user1ID") Long user1ID, @PathVariable("user2ID") Long user2ID) {
        FightGameDto fightGameDto = fightGameService.getFightGame(user1ID, user2ID);
        return new ResponseEntity<>(fightGameDto, HttpStatus.OK);
    }

    @PutMapping("{id}/setMove")
    public ResponseEntity<FightGameDto> setMove(@PathVariable("id") Long id, @RequestBody UserMoveDto userMoveDto) {
        FightGameDto updatedGame = fightGameService.setMove(id, userMoveDto);
        return new ResponseEntity<>(updatedGame, HttpStatus.OK);
    }

    @PutMapping("newTurn")
    public ResponseEntity<FightGameDto> setNewTurn(@RequestBody FightGameDto fightGameDto) {
        long id = fightGameDto.getId();
        FightGameDto updatedGame = fightGameService.setNewTurn(id);
        return new ResponseEntity<>(updatedGame, HttpStatus.OK);
    }

    @PutMapping("{id}/winner")
    public ResponseEntity<FightGameDto> declareWinner(@PathVariable("id") Long id) {
        FightGameDto updatedGame = fightGameService.declareWinner(id);
        return new ResponseEntity<>(updatedGame, HttpStatus.OK);
    }

}
