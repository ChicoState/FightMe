package com.backend.backend.fightGame;

import com.backend.backend.fightGame.Dto.FightGameDto;
import com.backend.backend.user.Dto.UserDto;

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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.backend.backend.fightGame.FightGameService;

@RestController
@RequestMapping("/api/fightgames")
@AllArgsConstructor
// @CrossOrigin(origins = "http://localhost:60966")
@CrossOrigin(origins = "*")
public class FightGameController {
    private FightGameService fightGameService;

    @PostMapping
    public ResponseEntity<FightGameDto> createFightGame(@RequestBody FightGameDto fightGameDto) {
        FightGameDto savedFightGame = fightGameService.createFightGame(fightGameDto);
        return new ResponseEntity<>(savedFightGame, HttpStatus.CREATED);
    }

    @PutMapping("{id}/winner")
    public ResponseEntity<FightGameDto> declareWinner(@PathVariable("id") Long id) {
        FightGameDto updatedGame = fightGameService.declareWinner(id);
        return new ResponseEntity<>(updatedGame, HttpStatus.OK);
    }
}
