package com.backend.backend.fightGame;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.backend.backend.ResourceNotFoundException;
import com.backend.backend.fightGame.FightGame;
import com.backend.backend.fightGame.FightGameRepository;
import com.backend.backend.fightGame.FightGameService;
import com.backend.backend.user.UserMapper;
import com.backend.backend.user.Dto.UserDto;
import com.backend.backend.fightGame.Dto.FightGameDto;

public class FightGameServiceImpl implements FightGameService{
    private FightGameRepository fightGameRepository;
    
    // START OF ALL CREATE

    @Override
    public FightGameDto createFightGame(FightGameDto fightGameDto) {
        FightGame fightGame = FightGameMapper.mapToFightGame(fightGameDto);
        FightGame savedGame = fightGameRepository.save(fightGame);
        return FightGameMapper
        .mapToFightGameDto(savedGame);
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
            FightGame savedGame = fightGameRepository.save(fightGame);
            return FightGameMapper.mapToFightGameDto(savedGame);
        }
        else {
            throw new ResourceNotFoundException("The game is not finished.");
        }
    }
}
